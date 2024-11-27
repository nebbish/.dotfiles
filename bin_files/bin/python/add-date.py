#!/usr/bin/env python3
import os, sys, platform, stat, datetime, argparse, shutil

def modification_date(path_to_file):
	"""
	Try to get the date that a file was modified
	"""
	if platform.system() == 'Windows':
		return os.path.getmtime(path_to_file)
	else:
		return os.stat(path_to_file).st_mtime

def creation_date(path_to_file):
	"""
	Try to get the date that a file was created, falling back to when it was
	last modified if that isn't possible.
	See http://stackoverflow.com/a/39501288/1709587 for explanation.
	"""
	if platform.system() == 'Windows':
		return os.path.getctime(path_to_file)
	else:
		stat = os.stat(path_to_file)
		try:
			return stat.st_birthtime
		except AttributeError:
			# We're probably on Linux. No easy way to get creation dates here,
			# so we'll settle for when its content was last modified.
			return stat.st_mtime

DEFAULT_FORMAT="%Y_%m_%d_%H_%M_%S"
def add_date(path, copy=False, use_create_time=False, prefix=False, format=DEFAULT_FORMAT):
	assert os.path.exists(path)
	if use_create_time:
		timestamp = creation_date(path)
	else:
		timestamp = modification_date(path)
	time_str = datetime.datetime.fromtimestamp(timestamp).strftime(format)

	is_dir = os.path.isdir(path)
	(dir_arg, fname_arg) = os.path.split(path)
	if is_dir:
		fname_arg = (fname_arg, '')
	else:
		fname_arg = os.path.splitext(fname_arg)
	if prefix:
		new_path = os.path.join(dir_arg, time_str + '_' + fname_arg[0] + fname_arg[1])
	else:
		new_path = os.path.join(dir_arg, fname_arg[0] + '_' + time_str + fname_arg[1])

	if copy:
		if os.path.isdir(path):
			shutil.copytree(path, new_path)
		else:
			shutil.copy(path, new_path)
	else:
		os.rename(path, new_path)
	return new_path

def main():
	parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter,
	                                 description="Rename/Copy specified file, adding the file mod/cre time as a suffix/prefix")
	parser.add_argument("path",
						help = "Specify the file to work with")
	parser.add_argument("-c", "--copy", action="store_true",
						help="If specified a copy will be made (vs just renaming the original)")
	parser.add_argument("--creation-date", action="store_true",
						help="Use the creation date instead of the modified date")
	parser.add_argument("-p", "--prefix", action="store_true",
						help="Prepend the calculated date (vs append which is default)")
	parser.add_argument("-f", "--format", default=DEFAULT_FORMAT,
						help="Specify the format string for the date (see 'strftime')")
	parser.add_argument("--show-args", action="store_true", dest="show_args", help="<internal>")

	cargs = parser.parse_args()
	if cargs.show_args:
		lines = pformat(cargs, indent=4).splitlines()
		args_str = '\n'.join(["    " + ln for ln in lines])
		print("Args:\n{}".format(args_str))
		sys.exit(0)

	new_path = add_date(cargs.path, cargs.copy, cargs.creation_date, cargs.prefix, cargs.format)
	print(new_path)
	return 0

if __name__ == '__main__':
	sys.exit(main())

