#!/usr/bin/env python3
import sys, os, re
from plumbum import cli, FG, RETCODE
from plumbum.cmd import vim, diff
from plumbum.commands.processes import ProcessExecutionError
import tempfile, shutil
import platform
from pathlib import Path
# import unicodedata
import struct
from datetime import datetime
import pdb


# in_win = any(platform.win32_ver())
in_win = platform.system().lower().startswith('win')

class TempDir():
    """Context manager for make temp directory."""
    def __init__(self, suffix=None, prefix=None, basedir=None):
        super().__init__()
        self.sfx, self.pfx, self.dir = suffix, prefix, basedir
        self.tempdir = None
        return

    def __enter__(self):
        self.tempdir = tempfile.mkdtemp(self.sfx, self.pfx, self.dir)
        assert os.path.isdir(self.tempdir)
        return self.tempdir

    def __exit__(self, *exc):
        if self.tempdir and os.path.isdir(self.tempdir):
            shutil.rmtree(self.tempdir)
        return

def longify(path, force=False):
    # This only matters on windows
    if not in_win: return path

    path = os.path.normpath(path)
    try:
        # This is only necessary on Python2 to PRE-convert to
        # unicode (so the Win32 API does not have to convert)
        path = path.decode('utf8')
    except:
        # It will blow up in Python3 but otherwise is harmless
        pass
    if path[:4] != u'\\\\?\\':
        # Adding a limiter -- to only add this when the length demands it.
        # This limiter is a **band-aid** to avoid a real problem:
        #    the GNU `diff` utility cannot handle the prefix :(
        # the error:
        #    assert rc in [0, 1], f"Got a 'not found' return code from 'diff':  {rc}"
        if len(path) > 250 or force:
            path = u'\\\\?\\' + path
    return path

def os_walk(top, topdown=True, onerror=None, followlinks=False):
    """whole purpose:   to walk deep paths on windows"""
    ##
    ## NOTE:  even prepending the '\\?\' prefix and calling
    ##        the built-in, os.walk, is not enough to work
    ##
    # top = longify(top)

    try:
        names = os.listdir(top)
    except OSError as err:
        if onerror is not None:
            onerror(err)
        return

    dirs, nondirs = [], []
    for name in names:
        if os.path.isdir(os.path.join(top, name)):
            dirs.append(name)
        else:
            nondirs.append(name)

    if topdown:
        yield top, dirs, nondirs
    for name in dirs:
        new_path = os.path.join(top, name)
        if followlinks or not os.path.islink(new_path):
            for x in os_walk(new_path, topdown, onerror, followlinks):
                yield x
    if not topdown:
        yield top, dirs, nondirs

def get_computer_name_from_swp_file(swp_path):
    with open(swp_path, 'rb') as bf:
        """In my local SWP files with VIM 8.2 the SWP files
        have 68 bytes (0x44) before the computer name.
        Then the computer name seems to end at byte 108 (0x6C)"""
        bdata = bf.read()
        totlen, pfxlen = 0x6c, 0x44
        strlen = totlen - pfxlen 
        # always returns a tuple, even just one thing is returned - so [0] on end
        comp_name_buf = struct.unpack('{}x{}s'.format(pfxlen, strlen), bdata[:totlen])[0]
        # Also we opened in binary mode 'rb' above - convert to string
        comp_name_str = comp_name_buf.decode('utf-8')

    # has_more = not comp_name_str.endswith('\0')
    return comp_name_str.strip('\0') + ('' if comp_name_str.endswith('\0') else '...')


def recover_edits(start_root, depth, depth_first, rm_orphaned, rm_recovered, force, use_built_in_walk):
    rx_swap = re.compile(r'^(_|\.(.*))\.sw.$')
    if depth is not None:
        depth = int(depth)


    ##
    ## Create a remove helper that moves instead of deleting
    ##
    backup_tag = 'recovered_swp_files'
    timestr = datetime.now().strftime("%Y_%m_%d_%H_00_00")
    backup_name = '{}_{}'.format(backup_tag, timestr)
    backup_root = os.path.join(tempfile.gettempdir(), backup_name)
    def is_prior_backup(path):
        return os.path.basename(path).lower().startswith(backup_tag)

    def remove(path):
        if not os.path.exists(path):
            print('    error deleting SWP file (i.e. moving into backup area) -- SWP file not there')
            return
        # rel_path holds the full path except the drive (the [1:] does this)
        #          i.e.  relative to the drive :)
        rel_path = os.sep.join(Path(path).parts[1:-1])
        # NOTE:  currently this is my ONLY use of "pathlib", `Path.parts`
        #        perhaps the whole file should be made to use pathlib :)
        backup_path = longify(os.path.join(backup_root, rel_path), True)
        # NOTE:  longify is "forced" here because it is NOT FULL LENGTH yet.
        #        within `shutil.move` below, it is path-joined and becomes longer
        if not os.path.exists(backup_path):
            os.makedirs(backup_path)

        # When 'force' is not True -- we don't have to even check for existing backups.
        # we just let any errors from `shutil.move(...)` propagate
        try:
            if force:
                # Check for and clean up any pre-existing backup
                dst = longify(os.path.join(backup_path, os.path.basename(path)))
                if os.path.exists(dst):
                    os.remove(dst)

            shutil.move(longify(path), backup_path)
        except Exception as e:
            print(e)


    func = os.walk if use_built_in_walk else os_walk
    for (root, dirs, files) in func(longify(start_root), topdown=(not depth_first)):
        plain_root = root[4:] if root.startswith('\\\\?\\') else root
        # print("Processing:  {}".format(plain_root))

        ##
        ## Handle the situation when we encounter a previous run's backup area
        ##
        if is_prior_backup(root):
            dirs[:] = []
            continue

        ##
        ## Handle the depth parameter -- depending on where we started, we may already be too deep
        ## When we are recursing, we notice when we are at depth, and block going further
        ##
        if depth is not None:
            cur_depth = len(os.path.relpath(root, plain_root).split(os.sep))
            if cur_depth >= depth:
                dirs[:] = []	# dont process these dirs
                if cur_depth > depth:
                    pdb.set_trace() # debugging how we get here
                    continue		# and skip this dir

        for name in files:
            swp_match = rx_swap.match(name)
            if not swp_match:
                continue

            ##
            ## This new way of handling recovery (i.e. using TEMP files and `diff`)
            ## was inspired by S.O. answer here:
            ##    https://stackoverflow.com/a/63341/5844631
            ##
            ## TODO:  validate this works with the swaps for anonymous files, i.e. _.swp
            ##
            swp_path = os.path.join(root, name)
            if os.path.islink(swp_path):
                print('Skipping symbolic link: {}'.format(swp_path))
                continue
            print('Recovering:  {}'.format(swp_path))

            with TempDir() as workdir:
                rec_txt = os.path.join(workdir, "vim.recovery.txt")
                rec_fn = os.path.join(workdir, "vim.recovery.fn")
                (rc, stdout, stderr) = vim[
                    '-X', '-f', '-r', swp_path,     # read in the SWP file
                    '-c', 'w {}'.format(rec_txt),   # save the recovered contents to temp file
                    '-c', 'let fn=expand("%")',     # get original file name
                    '-c', 'new {}'.format(rec_fn),  # open 2nd temp file (to hold orig file name)
                    '-c', 'exec setline(1, fn)',    # write orig file name to 2nd temp file
                    '-c', 'w',                      # save 2nd temp file
                    '-c', 'qa!',                    # quit
                    ].run(retcode=None)
                print('    recovery analysis complete')

                # This should always be possible
                comp_name = get_computer_name_from_swp_file(swp_path)
                print('    found computer name:  {}'.format(comp_name))

                if rc != 0:
                    print('    skipping file, the recovery session quit with a non-zero exit code, {}'.format(rc))
                    continue

                m = re.search(r'process STILL RUNNING: (\d+)', stdout, re.I)
                if m:
                    print('    SWP file still in use by process {}'.format(m.group(1)))
                    continue

                m = re.search(r'Errors detected while recovering', stdout, re.I)
                if m:
                    # Check for a known situation that we want to continue and open the file
                    m = re.search(r'look for lines starting with \?\?\?', stdout, re.I)
                    if not m:
                        # For printing stdout, we clean out control characters that may be present (seen on MacOS)
                        cleanout = re.sub(r'(\x1b|\[\?\d+[lh]|\[\d+m)|\[\d+;\d+[Hr]|\[[HJ]', r'', stdout)
                        print('    errors found during recovery, skipping\n\t{}'.format('\n\t'.join(cleanout.splitlines())))
                        continue

                # At this point, more debugging would be necessary to see what is going on
                # Perhaps it means that VIM itself could not find the original file ?
                if not os.path.exists(rec_fn):

                    # This check for `rec_txt` and subsequent print is just for debugging/info
                    if not os.path.exists(rec_txt):
                        print('    no recovered temp file found')

                    print('    no original file found')
                    if rm_orphaned:
                        print('    deleting orphaned SWP file (i.e. moving into TEMP area)')
                        remove(swp_path)
                    continue


                # Now we are confident that the VIM commands completed, and there the 2nd temp file exists
                # and contains the file name of the originally edited file
                with open(rec_fn, 'r') as f:
                    orig_name = next(f).strip()

                # Next try to find the original file by first using what VIM thinks, then trying manual
                if not os.path.exists(orig_name):
                    orig_name = os.path.join(root, swp_match.group(2))
                if not os.path.exists(orig_name):
                    orig_name = os.path.join(root, '.' + swp_match.group(2))
                if not os.path.exists(orig_name):
                    print('    cannot find the original file')
                    if rm_orphaned:
                        print('    deleting orphaned SWP file (i.e. moving into TEMP area)')
                        remove(swp_path)
                    continue

                if orig_name == rec_txt:
                    # I think we recovered an anonymous file -- that had not yet been saved
                    # The set of '-c' commands we used would do the following for an anonymous file:
                    #   * saving to "rec_txt" would have set the filename of the "[No Name]" buffer just recovered
                    #   * retrieving that name with "expand('%')" would produce the path to the 1st temp file
                    #   * so in this situation, the 2nd temp file contents is the path of the 1st temp file
                    assert swp_match.group(1) == '_'

                    # Here we copy the recovered text file into the same path as the SWP file
                    # (not moving b/c we still may remove the SWP file into the backup area)
                    timestr = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
                    anon_path = os.path.join(root, 'recovered_anonymous_edit_{}'.format(timestr))
                    shutil.copy(longify(swp_path), longify(anon_path))
                else:
                    # Use the orig file name to compare against 1st temp file (recovered contents)
                    # (for the VIM command parsing, quotes cannot be used, instead backslash the spaces)
                    rc = diff['--strip-trailing-cr', '--brief', orig_name, rec_txt] & RETCODE
                    assert rc in [0, 1], f"Got a 'not found' return code from 'diff':  {rc}"

                    if rc == 0:
                        print('    nothing changed')
                    else:
                        print('    changes present, opening diff.')
                        if rm_recovered:
                            print('    NOTE: recovered SWP file will be deleted upon closing the diff')
                        vim['-f', '-n', '-d', orig_name, rec_txt] & FG

                if rm_recovered:
                    print('    deleting SWP file (i.e. moving into TEMP area)')
                    remove(swp_path)

        ##
        ## My OLD original way of handling this:  string parsing
        ##
        # def unlink(path):
        #     if cargs.preview:
        #         print('    would be deleting {}'.format(path))
        #         return
        #     print('    deleting {}'.format(path))
        #     os.remove(path)
        #
        # def check_call(*args, **kwargs):
        #     if cargs.preview:
        #         # pdb.set_trace()
        #         print('    would be running {}'.format(', '.join([str(args), str(kwargs)])))
        #         return
        #     print('    running {}'.format(', '.join([str(args), str(kwargs)])))
        #     subprocess.check_call(*args, **kwargs)
        #
        # anon_swap = False
        # edits = []
        # for name in files:
        #     m = rx_swap.match(name)
        #     if not m:
        #         continue
        #     if m.group(1) == '_':
        #         # pdb.set_trace()
        #         anon_swap = True
        #         continue
        #     if os.path.exists(os.path.join(root, m.group(2))):
        #         # pdb.set_trace()
        #         edits.append((m.group(2), name))
        #         continue
        #     if os.path.exists(os.path.join(root, '.' + m.group(2))):
        #         # pdb.set_trace()
        #         edits.append(('.' + m.group(2), name))
        #         continue
        #     p = os.path.join(root, name)
        #     if cargs.remove_orphaned:
        #         print('Deleting orphaned swap file:  [{}]'.format(p))
        #         unlink(p)
        #     else:
        #         print('Found orphaned swap file:  [{}]'.format(p))
        #
        # for (src, swp) in edits:
        #     print('Recovering edit session for:  [{}]'.format(os.path.join(plain_root, src)))
        #     check_call(['gvim.bat', '-f', '-r', src], shell=True, cwd=plain_root)
        #     if cargs.remove_recovered:
        #         unlink(os.path.join(root, swp))
        #
        # if anon_swap:
        #     print("Recovering UN-NAMED in folder:  [{}]".format(plain_root))
        #     check_call(['gvim.bat', '-f', '-r'], shell=True, cwd=plain_root)

    return 0

##
## The `App` object is really only used for handling the command line,
## and calling the key worker function above
##
class App(cli.Application):
    """
    This command will search for VIM 'swap' files in the specified root
    and for each one found, it will:
    1.  Silently open a VIM session to recover it, saving the recovered contents to a temp file
    2.  Then compare the temp file to the original to see if anything was in fact recovered
    3.  If something recovered, open up a "diff mode" VIM session to view the recovery
    4.  Delete the temp files, and based on cmd-line options, possibly also the swap files
    """
    VERSION = "1.0"

    depth = cli.SwitchAttr(["d", "depth"], str, default=None, help='how deep to search')

    depth_first = cli.Flag(["df", "depth-first"], default=False,
                           help='search depth first')
    rm_orphaned = cli.Flag(["ro", "remove-orphaned"], default=False,
                           help="remove .swp files when matching file is missing")
    rm_recovered = cli.Flag(["rr", "remove-recovered"], default=False,
                            help="remove .swp files after having recovered it")
    force = cli.Flag(["f", "force"], default=False,
                     help='Overwrite any pre-existing backup when removing a handled swap file')
    use_built_in_walk = cli.Flag(["b", "built-in"], default=False,
                                 help="use built-in os.walk -vs- custom local def")

    @cli.positional(str)
    def main(self, root=os.getcwd()):
        return recover_edits(root,
                             self.depth,
                             self.depth_first,
                             self.rm_orphaned,
                             self.rm_recovered,
                             self.force,
                             self.use_built_in_walk)

if __name__ == '__main__':
    App.run()

