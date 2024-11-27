#!/usr/bin/env python3

import sys, os, re, logging, inspect, argparse
from pprint import pprint, pformat
from collections import deque
import codecs

import pdb

# Disable PYC files for our user-modules
sys.dont_write_bytecode = True

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def app_log():
    return logging.getLogger(__name__ if __name__ != '__main__' else os.path.splitext(os.path.basename(__file__))[0])
app_log().setLevel(logging.DEBUG)


class opener(object):
    def __init__(self, path=None, mode='r'):
        self.fh = None
        self.path = path
        if mode not in ['r','w']:
            raise Exception('provided mode [{}] is not yet supported by the "opener" class'.format(mode))
        self.mode = mode

    def __enter__(self):
        if self.path is not None:
            self.fh = open(self.path, self.mode)
            return self.fh
        if self.mode == 'r':
            # OLD code, just return standard handle (no need to close)
            #           adjusted in favor of handling possible BOM just below
            # return sys.stdin

            # NOTE:  if VIM is calling this script as an external program, it will
            #        PREPEND the BOM to the portion of the buffer sent to the external
            #        program WHEN the buffer itself starts with a BOM.
            #        (see:  https://stackoverflow.com/q/51480423/5844631)
            self.fh = codecs.getreader('utf_8_sig')(sys.stdin, errors='replace')
            return self.fh
        return sys.stdout

    def __exit__(self, exception_type, exception_value, traceback):
        if self.fh:
            self.fh.close()


class Tee(object):
    """
    This object is designed to intercept a STD stream (stdout/stderr)

    The purpose is to "log" that intercepted output so the STD output can be preserved for
    "offline" or later analysis.  Very handy when this script runs in an automated environment

    log_name:   this is the name of the logger used
    log_path:   the desination log file (can be omitted and added later via set_destination())
    echo:       controls whether the messages are echoed to the original file handle

    NOTE:  'set_destination' will fail if a log_path has already been set up
           (either during construction, or via a previous call to set_destination)
    """
    def __init__(self, orig_fh, log_name, log_path=None, echo=True):
        self.orig_fh = orig_fh
        self.handler = None
        self.echo = echo
        self.logger = logging.getLogger(log_name)
        self.logger.setLevel(logging.INFO) # info is ok, cause 'info()' is all we use in here
        #self.logger.addHandler(logging.NullHandler())
        if log_path is not None:
            self.set_destination(log_path)

    def orig_out(self):
        return self.orig_fh

    def make_filter(self, name):
        class TeelogFilter(logging.Filter):
            def __init__(self, myname, name_to_filter):
                self.myname = myname
                self.name_to_filter = name_to_filter
            def filter(self, record):
                if record.name == self.name_to_filter:
                    return False
                return True
        return TeelogFilter(name, self.logger.name)

    def logger_name(self):
        return self.logger.name

    def set_echo(self, value):
        self.echo = value

    def set_destination(self, path):
        assert(self.handler is None)
        self.handler = logging.FileHandler(path)
        self.handler.setFormatter(logging.Formatter('%(asctime)s : %(message)s'))
        self.logger.addHandler(self.handler)

    def write(self, text):
        ##
        ##  NOTE: the built-in print() function always calls us at least twice
        ##        once with the args the user provided - then with just '\n'
        if self.echo:
            # for echoing, just pass the raw text through every time
            self.orig_fh.write(text)
        # but for logging, we ignore strings that are just '\n'
        if text != '\n':
            self.logger.info(text.rstrip())

    def flush(self):
        self.orig_fh.flush()

    def __getattr__(self, name):
        """ Forwards to the original file handle """
        return getattr(self.orig_fh, name)


class App(object):
    """
    Reads the data provided, sorts the lines and prints them back out
    (keeps all input in memory until EOF is encountered - then output begins)
    """
    def __init__(self):
        self.log = app_log().getChild('App')
        self.app_name = app_log().name
        self.args = None
        self.unknown_args = None

        ##
        ## Next, intercept the NORMAL std handles with the Tee() object defined above
        ## It can be configured to echo or not - and to log or not
        ## It starts with echo as True, and no logging
        ##
        sys.stdout = self.teeout = Tee(sys.stdout, '{0}.stdout'.format(self.app_name))
        sys.stderr = self.teeerr = Tee(sys.stderr, '{0}.stderr'.format(self.app_name))

        ##
        ## Finally, setup the root logger to process every message, but install
        ## a stream handler that will initially only allow warnings and above
        ##
        ## NOTE:    for this stream handler, we add a filter that will block records
        ##          logged by our STD handle intercepters (installed just below)
        ##          so the intercepted STD output will not get re-printed
        ##
        self.consoleHandler = logging.StreamHandler(self.teeerr.orig_out())
        self.consoleHandler.setLevel(logging.ERROR)
        self.consoleHandler.setFormatter(logging.Formatter('%(name)-25s : %(levelname)-8s : %(message)s'))
        self.consoleHandler.addFilter(self.teeout.make_filter('root_console_handler'))
        self.consoleHandler.addFilter(self.teeerr.make_filter('root_console_handler'))
        logging.getLogger('').setLevel(logging.DEBUG)
        logging.getLogger('').addHandler(self.consoleHandler)

        ##
        ## Specific init items
        ##
        self.targets = {}
        self.starts = {}
        self.build_data = { 'summary':[], 'env':{} }

    def parseCmdLine(self, user_args=None, want_unknowns=False):
        ##
        ## Construct the parser, and setup the options
        ##
        parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
                                         description=inspect.getdoc(self))

        ##
        ## Handy options that should be available on every cmd-line script
        ##
        parser.add_argument("-l", "--logdir", dest="logdir", default=None,
                            help="specify the folder for our various log files")
        parser.add_argument("-ll", "--log-level", dest="log_level", default='info',
                            choices=['debug', 'info', 'warn', 'error', 'critical'],
                            help="specify the log level (requires --logdir to be specified")
        parser.add_argument("-q", "--quiet", dest="quiet", default=0, action="count",
                            help="don't print results or status messages to stdout")
        parser.add_argument("-v", "--verbose", dest="verbose", default=0, action="count",
                            help="log 'info' level messages to STDOUT (normally >= warnings go there)")

        ##
        ## Here are the options specific to this cmd-line script
        ##
        parser.add_argument("buildlog", default=None, nargs="?",
                            help="Specify the build log file")
        # note:  b/c this has BOTH 'append' action and '*' nargs -- it will be a list 0f lists
        parser.add_argument("-p", "--proj-num", default=[], nargs="*", action="append",
                            help="Specify the project to process (vs whole log)")
        parser.add_argument("-w", "--write", action="store_true",
                            help="If present, writes the result to an output file")
        parser.add_argument("-s", "--summary", action="store_true",
                            help="If present, writes the summary as well")
        parser.add_argument("-a", "--starts", action="store_true",
                            help="If present, just prints the lines of each target's start")

        parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")

        ##
        ## Next, run the parser and save the arguments to our data members
        ##
        self.args, self.unknown_args = parser.parse_known_args(args=user_args)

        if self.args.show_args:
            lines = pformat(self.args, indent=4).splitlines()
            args_str = '\n'.join(["    " + ln for ln in lines])
            print("Args:\n{}".format(args_str))
            sys.exit(0)

        ##
        ## Handle quiet or verbose
        ##
        if self.args.quiet > 0:
            if self.args.verbose > 0:
                raise Exception('Both -q and -v cannot both be specified on cmd-line')
            self.teeout.set_echo(False)
            if self.args.quiet > 2:
                self.consoleHandler.setLevel(logging.CRITICAL + 1)
                self.teeerr.set_echo(False)
            elif self.args.quiet > 1:
                self.consoleHandler.setLevel(logging.CRITICAL)
                self.teeerr.set_echo(False)
        elif self.args.verbose > 2:
            self.consoleHandler.setLevel(logging.DEBUG)
        elif self.args.verbose > 1:
            self.consoleHandler.setLevel(logging.INFO)
        elif self.args.verbose > 0:
            self.consoleHandler.setLevel(logging.WARN)

        ##
        ## Handle the logdir if provided.
        ##
        if self.args.logdir is not None:
            ## Make sure the folder exists, or create it - then build the 3 output file paths
            if not os.path.exists(self.args.logdir):
                os.makedirs(self.args.logdir)
            self.logdir = os.path.abspath(self.args.logdir)

            ##
            ## The main script will create 3 files:
            ##
            ##      <app_name>_logger.txt   Filled by the Root logger
            ##      <app_name>_stdout.txt   Filled by what our stdout Tee() interceptor catches
            ##      <app_name>_stderr.txt   Filled by what our stderr Tee() interceptor catches
            ##
            fh = logging.FileHandler(os.path.join(self.logdir, '{0}_logger.txt'.format(self.app_name)))
            fh.setFormatter(logging.Formatter('%(asctime)s : %(threadName)-10s : %(name)-25s : %(levelname)-8s : %(message)s'))
            fh.setLevel(self.args.log_level.upper())
            logging.getLogger('').addHandler(fh)
            self.teeout.set_destination(os.path.join(self.logdir, '{0}_stdout.txt'.format(self.app_name)))
            self.teeerr.set_destination(os.path.join(self.logdir, '{0}_stderr.txt'.format(self.app_name)))

        ##
        ## Next handle the specific options
        ##
        if self.args.buildlog is not None and not os.path.exists(self.args.buildlog):
            raise argparse.ArgumentTypeError("The specified build log [{}] cannot be found".format(self.args.infile))

        ##
        ## Here we return the options in case 'main' wants them
        ##
        if want_unknowns:
            return self.args, self.unknown_args
        return self.args

    def DoWork(self):
        if self.args.buildlog is None:
            # NOTE:  if VIM is calling this script as an external program, it will
            #        PREPEND the BOM to the portion of the buffer sent to the external
            #        program WHEN the buffer itself starts with a BOM.
            #        (see:  https://stackoverflow.com/q/51480423/5844631)
            # NOTE:  for PY2 we pass in `sys.stdin`, but for PY3 it must be `sys.stdin.buffer`
            #        i have not tested whether PY3's encoding detection handles BOM's in STDIN
            #        instead, I just adjusted to keep the code that I know can handle it
            with codecs.getreader('utf_8_sig')(sys.stdin.buffer, errors='replace') as stdin:
                self._dowork(stdin)
        else:
            with open(self.args.buildlog, 'r') as log:
                self._dowork(log)

        # Only print the errors if we were passed a file path to open ourselves and process
        # Otherwise, it will likely just pollute the "pipeline" we are likely a part of
        self._write_processed_lines(print_errors=(self.args.buildlog is not None))
        return 0

    class Target(object):
        def __init__(self, target_id, node=None):
            self._id = target_id
            self._node = node
            self._target = None
            self._project = None
            self._output = {}  # keys are timestamps -- values are arrays of lines from that timestamp
            self._def_time = '00:00:00.000'
            self._cur_time = self._def_time
            self._errors = []
            self._status_lines = []
            self._last_marked_line = ''

        @property
        def id(self):
            return self._id

        @property
        def errors(self):
            return self._errors

        @property
        def node(self):
            return self._node

        @node.setter
        def node(self, value):
            if self._node is None:
                self._node = value
            elif self._node != value:
                self._errors.append(f"Attempting to change 'node' from {self._node} to {value}")

        @property
        def target(self):
            return self._target

        @target.setter
        def target(self, value):
            if self._target is None:
                self._target = value
            elif self._target != value:
                self._errors.append(f"Attempting to change 'target' from {self._target} to {value}")

        @property
        def project(self):
            return self._project

        @project.setter
        def project(self, value):
            if self._project is None:
                self._project = value
            elif self._project != value:
                self._errors.append(f"Attempting to change 'project' from {self._project} to {value}")

        def start(self, ln, project, target):
            self.project = project
            self.target = target
            self._status_lines.append(ln)

        def done(self, project, target):
            if self._project is None:
                self._errors.append(f"Project first appeared in log without something starting it")
            self.project = project
            self.target = target

        def set_current_time(self, time):
            if time is not None:
                if time not in self._output:
                    self._output[time] = []
                self._cur_time = time

        def add_line(self, ln, marked_line=False):
            if self._cur_time not in self._output:
                self._output[self._cur_time] = []
            if marked_line:
                # 99% of the time this is just a line to indicate we switched back to
                # this project in an interleaved multi-threaded multi-project build.
                # Still, we only skip saving it if it exacly matched the last one
                if ln == self._last_marked_line:
                    return
                self._last_marked_line = ln
            if ln and ln in self._output[self._cur_time]:
                if ln.startswith(self._cur_time):
                    return
            self._output[self._cur_time].append(ln)

            lln = ln.lower()
            if '\\cl.exe ' in lln and '\\tracker.exe ' not in lln:
                self.processCompileArgs(ln)

        def processCompileArgs(self, ln):
            (_, argstring) = re.split(r'cl.exe\s+', ln, flags=re.I)
            # Split with Regex to allow for quoted values
            arglist = re.split(r'((?:/D )?(?:"(?:\\.|[^"])+"|\S)+)', argstring, flags=re.I)
            # Remove blanks
            arglist = [a for a in arglist if a.strip()]
            # pprint(arglist)

            opts = []
            files = []
            for arg in arglist:
                dest = opts if arg[0] == '/' else files
                dest.append(arg)

            defines = []
            for opt in opts:
                if opt[:2].lower() == '/d':
                    defines.append(opt)

            # print(files)
            return

        def output(self):
            if self._output:
                if self._def_time in self._output.keys():
                    assert len(self._output.keys()) == 1
                for time in sorted(self._output.keys()):
                    for ln in self._output[time]:
                        yield ln
            else:
                for ln in self._status_lines:
                    yield ln

    def _proj_match(self, projmark):
        # NOTE:  this function builds a matching function and caches it

        if not hasattr(self, '_proj_match_work_func'):
            if self.args.starts:
                # If we're just collecting start lines, *always* return False
                work_func = lambda id: False
            elif not self.args.proj_num:
                # If the user speciifed nothing save it all, *always* return True
                work_func = lambda id: True
            else:
                # Ok the user specified, setup a filter function:
                proj_exprs = []
                # --proj-num cmd-line option is returned as a list-of-lists, see above
                proj_opts = [opt for sublist in self.args.proj_num for opt in sublist]
                for expr in proj_opts:
                    if '*' not in expr:
                        proj_exprs.append(re.compile(r'^' + expr + r'$'))
                        continue
                    (main, sub) = expr.split(':')
                    if main == '*':
                        assert sub != '*'
                        proj_exprs.append(re.compile(r'^\d+:' + sub + r'$'))
                    else:
                        proj_exprs.append(re.compile(r'^' + main + r'(?::\d+)?$'))
                work_func = lambda id: any([rx.match(id) for rx in proj_exprs])

            # Save the lambda into the attribute for easy re-use
            self._proj_match_work_func = work_func

        return self._proj_match_work_func(projmark)

    def _dowork(self, log_obj):
        opt_time_expr = r'(?:(\d+:\d+:[\d.]+))?'
        # NOTE:  I just learned that TAB characters will be present for 
        #        sub-builds that restart project numbers at 1>
        #        At the same time, it appears that TABs are never used
        #        as the initial indent. It seems that MSBuild lines up
        #        the '>' characters, and space based indenting makes
        #        that easier.
        opt_indent = r' *'
        proj_mark = r'(\d+(?::\d+)?)>'

        rx_proj = re.compile(r'^' + opt_time_expr + opt_indent + proj_mark)
        rx_env  = re.compile(r'^(\w+) = (.*)$')

        ##
        ## NOTE:  there are two kinds of lines that seems to be the "start" of the projects
        ##        (applies to all but the "minimal" verbosity)
        ##
        ##            a)  {id}>Project "{path}" on node {node} ({target} target ...
        ##        -or-
        ##            b)  {id}>Project "{path}" {id} is building {path2} {id2} on node {node} ({target} target ...
        ##
        ##        (a) is always for the first project -- and a few more, but I'm not sure why
        ##        (b) is for almost all of the rest
        ##
        proj_start  = r'Project "(.*?)" (?:\((.*?)\) is building "(.*?)" \((.*?)\) )?on node (\S+) \((.*?) target'
        proj_done   = r'[Dd]one [Bb]uilding [Pp]roject "(.*?)" \((.*?) target'
        rx_start = re.compile(proj_start)
        rx_done  = re.compile(proj_done)


        trouble = r'37>c:\program files (x86)\windows kits\10\include\10.0.17134.0\um\winnt.h:19536'

        def add_start(ln, projmark, childmark):
            starter = projmark if childmark else None
            started = childmark if childmark else projmark
            assert started not in self.starts
            self.starts[started] = (starter, ln)

        ##
        ## These four helpers are called from within the loop just below
        ##
        # pdb.set_trace()
        state = {}
        def save_line(ln, marked_line=False):
            if 'curtarg' not in state:
                self.build_data['summary'].append(ln)
            elif self._proj_match(state['curtarg'].id):
                state['curtarg'].add_line(ln, marked_line)

        def start_target(ln, time, projmark, projpath, projid, childpath, childmark, node, target):
            assert 'curtarg' in state
            assert state['curtarg'].id == projmark
            if not childpath:
                state['curtarg'].start(ln, projpath, target)
            else:
                if childmark not in self.targets:
                    self.targets[childmark] = App.Target(childmark, node=node)
                self.targets[childmark].start(ln, childpath, target)
            # Now that the started project is sure to exist... update our "start flow" data
            add_start(ln, projmark, childmark)

        def target_done(time, projmark, projpath, target):
            assert 'curtarg' in state
            assert state['curtarg'].id == projmark
            state['curtarg'].done(projpath, target)
            del state['curtarg']

        def switch_target(time, projmark):
            if projmark not in self.targets:
                self.targets[projmark] = App.Target(projmark)
            state['curtarg'] = self.targets[projmark]

        ##
        ## This is sometimes present (not for "minimal" logging) -- one time near the top
        ## There is a bug in MSBuild output where this message is not on it's own line
        ## and instead is like a prefix before whatever line happens to be printed next
        ##
        ## We look for it until we've found it, then stop looking.
        ## Also, we extract it from the line it pollutes before continuing parsing that line
        ##
        logging_verbosity = None
        rx_log = re.compile(r'^Logging verbosity is set to: (\w+).')

        ## These two values are only helpful when debugging -- to get a picture
        ## of where in the parsing you are while stepping throug this loop
        last_few_lines = deque(maxlen=10)
        line_num = 0

        try:
            for line in log_obj:
                ln = line.rstrip()

                line_num += 1
                last_few_lines.append(ln)

                if line_num % 500000 == 0:
                    msg = ln if len(ln) < 50 else ln[:50] + '...'
                    eprint(f'Processing line {line_num} {msg}')

                if logging_verbosity is None:
                    m = rx_log.match(ln)
                    if m:
                        logging_verbosity = m.group(1)
                        ln = ln[m.end():]

                m = rx_env.match(ln)
                if m:
                    (k,v) = m.groups()
                    self.build_data['env'][k] = v
                    continue

                ##
                ## Most lines get here, and we do one of three things if it's got a "project mark":
                ##
                ##   START:       setup 'current' target, and save line -- and DONE with line
                ##
                ##   END:         save line, then remove 'current' target -- and DONE with line
                ##
                m = rx_proj.match(ln)
                if m:
                    (time, projmark) = m.groups()
                    proj_msg = ln[m.end():]

                    ## First and always -- switch to the specified target (creating if needed)
                    switch_target(time, projmark)

                    ##
                    ## Then in order:
                    ##   - handle start detection
                    ##   - save the line  (req. `continue` to skip rest of line loop)
                    ##   - handle done detection
                    ##
                    m = rx_start.match(proj_msg)
                    if m:
                        start_target(ln, time, projmark, *m.groups())
                    save_line(ln, True)
                    if not m:
                        m = rx_done.match(proj_msg)
                        if m:
                            target_done(time, projmark, *m.groups())

                    ## At this point a project-marked line should be completely handled
                    continue

                ##
                ## Here we trust that 'curtarg' is setup correctly
                ## and just save the line in the right place
                ##
                save_line(ln)
        except:
            print('Exception while processing log file, recently processed lines:')
            print('\t' + '\n\t'.join(last_few_lines))
            print('\t[end-of-lines]')
            raise

        # At this point, the last lines are not project lines, so we should not have a current project
        assert 'curtarg' not in state

    def _write_processed_lines(self, print_errors=False):
        if print_errors:
            ids_with_bad_start = [v for v in self.targets.values() if v.errors]
            if ids_with_bad_start:
                eprint(f"Found lines that belonged to an unexpected target(s):")
                for targ in ids_with_bad_start:
                    eprint(f'\t{targ.id}\n\t\t' + '\n\t\t'.join(targ.errors))


        # `bdir` is referenced in multiple places below depending on cmd-line options
        (bdir, bfile) = os.path.split(self.args.buildlog)

        if self.args.write:
            if self.args.proj_num:
                targ = self.targets[self.args.proj_num]
                name = os.path.splitext(os.path.basename(targ.project))[0]
                outfile = os.path.join(bdir, 'parsed--{}-only--{}'.format(name, bfile))
            else:
                outfile = os.path.join(bdir, 'parsed--sorted--{}'.format(bfile))
        else:
            outfile = None

        # Converting each product ID (e.g. '4', '4:3', '103', '39:10') into something that sorts nicely
        id_to_key = lambda x: tuple([int(v) for v in x.split(':')])
        with opener(outfile, 'w') as out:
            for key in sorted(self.targets.keys(), key=id_to_key):
                # Only print the "start flow" if we were asked to print this project
                if self._proj_match(key):
                    if key in self.starts:
                        # Using '.pop()' below since this segment of launch flow is getting printed
                        # and this ensures that later "flows" that print will stop when they get here
                        # so that each portion of the flow is only printed once.
                        (starter, ln) = self.starts.pop(key)
                        launch_flow = [ln]
                        while starter and starter in self.starts:
                            (starter, ln) = self.starts.pop(starter)
                            launch_flow.insert(0, ln)
                        out.write('\n'.join(launch_flow) + '\n')

                # Then print the output if this project was asked for --OR-- all starts were asked for
                # Print the output 
                if self._proj_match(key) or self.args.starts:
                    for ln in self.targets[key].output():
                        out.write(ln + '\n')
            if self.args.summary:
                out.write('\n' + '\n'.join(self.build_data['summary']) + '\n')

        if self.args.write:
            if self.build_data['env']:
                outfile = os.path.join(bdir, 'parsed--env--{}'.format(bfile))
                with open(outfile, 'w') as out:
                    for var in sorted(self.build_data['env'].keys()):
                        val = self.build_data['env'][var]
                        out.write('{} = {}\n'.format(var, val))



## This is the main function, called from below
def main():
    logging.getLogger().addHandler(logging.NullHandler())

    ## Initialize the application object, and parse the command line
    ## (see App for all the work done here)
    app = App()
    args = app.parseCmdLine()

    return app.DoWork()


##
## Now do the main work!
##
if __name__ == '__main__':
    sys.exit(main())

