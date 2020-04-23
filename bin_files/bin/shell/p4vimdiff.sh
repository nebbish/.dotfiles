#!/bin/sh

#
# NOTE:  this is one of the first scripts I wrote - and it was arduous to learn as I went with some of these concepts
#        I could probably clean up a lot - but I'm leaving that for later, the script still works great :)
#
if [ -z "$1" ]; then
	thisname="$( basename "$0" )"
	echo -e "Usage:  $thisname <file1> <file2> [<file3>]\nA bash script that can be used with P4V to launch and use GVIM as the diff/merge tool"
	exit 1
fi

#
# NOTE:  if you want 'GUI' vim, be sure to put -f on the command line
#        so it does not self-fork away from its parent process
#        (-f = foreground, and only applies to GUI vim)
#
#
# The 'vim' installed, does not honor the '-g' option to launch the gui
# If you want that you have to use the 'gvim*' binaries
#
#
# The non-gui vim - will not be displayed unless some trickery I don't
# have under my belt is added here, so that the script launched by P4V
# first opens a terminal window so that it can be seen.
#
# Without that, the program is launched and waited upon - just not seen
#

#DIFFPREPCMDS=(+"colorscheme evening" +"set diffopt+=iwhite" +"set lines=9999" +"set columns=9999" +"wincmd =" +"normal gg]c")
DIFFPREPCMDS=(+"colorscheme evening" +"set lines=9999" +"set columns=9999" +"wincmd =" +"normal gg]c")

#do_gvim_test() {
#	# This was intended to be the beginning of a solution which allows multiple 'diffs'
#	# to be launched from Perforce, and all living in a single instance of GVim.
#	# However my initial test below (using --remote-silent) didn't work out so good.
#	# Therefore, I was thinking about using these instructions:
#	#	http://stackoverflow.com/questions/4444547/using-single-vim-instance-with-remote-silent
#	echo "calling 'do_gvim'..."
#	#exec "/usr/bin/gvim" -d --remote-silent "$1" "$2" || exit $?
#	#exec "/usr/bin/gvimdiff" --remote-silent "$1" "$2" || exit $?
#}

#do_diff() {
#	#GVIM_SERVERS=$(/usr/bin/gvim --serverlist)
#	#if [ -z $GVIM_SERVERS ]; then
#		#exec /usr/bin/gvim "${DIFFPREPCMDS[@]}" -d "$1" "$2" || exit $?
#	#else
#		#DIFFCMD="vert diffsplit $2 | colorscheme evening | set lines=9999 | set columns=9999 | wincmd ="
#		#exec /usr/bin/gvim --remote-tab +"${DIFFCMD}" "$1" || exit $?
#	#fi
#
#	DIFFCMD="vert diffsplit $2 | colorscheme evening | set lines=9999 | set columns=9999 | wincmd ="
#	exec /usr/bin/gvim --remote-tab-silent +"${DIFFCMD}" "$1" || exit $?
#}

do_gvim() {
	#
	# These were my attempts at storing my gvim arguments in a variable for re-use
	# NONE of them worked.  I had to use the array you see above
	#
	#	cmd_val='/usr/bin/gvim'
	#	cmd_val='~/bin/showargs.sh'
	#	var_method=10
	#	exec_method=1
	#	case $var_method in
	#		11)	DIFFPREPCMDS="+\"set lines=9999\" +\"set columns=9999\" +\"wincmd =\" +\"wincmd w\" +\"normal gg]c\""	;;
	#		12)	DIFFPREPCMDS="\+\"set lines=9999\" \+\"set columns=9999\" \+\"wincmd =\" \+\"wincmd w\" \+\"normal gg]c\""	;;
	#		13)	DIFFPREPCMDS="\"+set lines=9999\" \"+set columns=9999\" \"+wincmd =\" \"+wincmd w\" \"+normal gg]c\""	;;
	#		14)	DIFFPREPCMDS="\"\+set lines=9999\" \"\+set columns=9999\" \"\+wincmd =\" \"\+wincmd w\" \"\+normal gg]c\""	;;
	#
	#		21)	DIFFPREPCMDS='+"set lines=9999" +"set columns=9999" +"wincmd =" +"wincmd w" +"normal gg]c"'				;;
	#		22)	DIFFPREPCMDS='"+set lines=9999" "+set columns=9999" "+wincmd =" "+wincmd w" "+normal gg]c"'				;;
	#
	#		31)	DIFFPREPCMDS="+'set lines=9999' +'set columns=9999' +'wincmd =' +'wincmd w' +'normal gg]c'"				;;
	#		32)	DIFFPREPCMDS="\+'set lines=9999' \+'set columns=9999' \+'wincmd =' \+'wincmd w' \+'normal gg]c'"		;;
	#		33)	DIFFPREPCMDS="'+set lines=9999' '+set columns=9999' '+wincmd =' '+wincmd w' '+normal gg]c'"				;;
	#	esac
	#	case $exec_method in
	#		2)	exec $cmd_val "${DIFFPREPCMDS}" -d "$1" "$2" || exit $?	;;
	#		3)	exec $cmd_val ${DIFFPREPCMDS} -d "$1" "$2" || exit $?	;;
	#		4)	exec $cmd_val '"'${DIFFPREPCMDS}'"' -d "$1" "$2" || exit $?	;;
	#		5)	exec $cmd_val "'"${DIFFPREPCMDS}"'" -d "$1" "$2" || exit $?	;;
	#
	#		99)	exec '/usr/bin/gvim' "${DIFFPREPCMDS}" -d "$1" "$2" || exit $?	;;
	#		99)	exec '/usr/bin/gvim' ${DIFFPREPCMDS} -d "$1" "$2" || exit $?	;;
	#	esac

	/usr/bin/gvim "${DIFFPREPCMDS[@]}" -d "$@" || exit $?
	#echo "===---===---===--- Command that works ---===---===---==="
	#exec /usr/bin/gvim +'set lines=9999' +'set columns=9999' +'wincmd =' +'wincmd w' +'normal gg]c' -d "$1" "$2" || exit $?
}

do_merge() {
	cookie=$1
	if [ $cookie != "vimdiffcookie" ]; then
		echo "Something went wrong launching this script"
		exit -1
	fi
	base_arg=$2
	theirs_arg=$3
	ours_arg=$4
	merged_arg=$5

	pfx="${theirs_arg%%(*)*}/"
	ext="${theirs_arg##*.}"
	src_file="${pfx}source (thiers).$ext"
	base_file="${pfx}base (orig).$ext"
	targ_file="${pfx}target (yours).$ext"

	if [ -d "$pfx" ]; then
		echo "Error preping for merge:  the temp dir we want to use [$pfx] already exists"
		exit -1
	fi

	mkdir -p $pfx
	cp "$base_arg" "$base_file"
	cp "$theirs_arg" "$src_file"
	cp "$ours_arg" "$targ_file"

	base_orig_hash=($(md5sum "$base_file"))
	src_orig_hash=($(md5sum "$src_file"))
	targ_orig_hash=($(md5sum "$targ_file"))
	base_mod_date=$(stat -c %Y "$base_file")
	src_mod_date=$(stat -c %Y "$src_file")
	targ_mod_date=$(stat -c %Y "$targ_file")

	#"/usr/bin/gvim" "${DIFFPREPCMDS[@]}" -df --remote-silent "$src_file" "$base_file" "$targ_file" || exit $?
	#"/usr/bin/gvim" "${DIFFPREPCMDS[@]}" -df "$src_file" "$base_file" "$targ_file" || exit $?
	do_gvim -f "$src_file" "$base_file" "$targ_file" || exit $?

	base_new_hash=($(md5sum "$base_file"))
	src_new_hash=($(md5sum "$src_file"))
	targ_new_hash=($(md5sum "$targ_file"))
	base_new_date=$(stat -c %Y "$base_file")
	src_new_date=$(stat -c %Y "$src_file")
	targ_new_date=$(stat -c %Y "$targ_file")


	declare -a files
	lastidx=${#files[@]}
	if [ $src_orig_hash != $src_new_hash ]; then
		files[$lastidx]=$src_file
	elif [ $src_new_date -gt $src_mod_date ]; then
		files[$lastidx]=$src_file
	fi
	lastidx=${#files[@]}
	if [ $base_orig_hash != $base_new_hash ]; then
		files[$lastidx]=$base_file
	elif [ $base_new_date -gt $base_mod_date ]; then
		files[$lastidx]=$base_file
	fi
	lastidx=${#files[@]}
	if [ $targ_orig_hash != $targ_new_hash ]; then
		files[$lastidx]=$targ_file
	elif [ $targ_new_date -gt $targ_mod_date ]; then
		files[$lastidx]=$targ_file
	fi
	numchanged=${#files[@]}
	echo "Num changed:  ${numchanged}"

	if [ $numchanged -eq 1 ]; then
		cp "${files[0]}" "$merged_arg"
		#read -p "Only one file changed. press enter to continue"
	#elif [ $numchanged -eq 0 ]; then
		#read -p "No files appear changed. press enter to continue"
	elif [ $numchanged -gt 1 ]; then
		maxidx=$numchanged
		while true; do
			echo "List of files that changed during the merge..."
			for ((i=0; i < $maxidx; i++)); do
				idx=$((i + 1))
				echo "    $idx) ${files[$i]}"
			done
			read -p "Which file do you want to use as the merged result?  " fno
			if [ $fno -gt 0 ] && [ $fno -le $maxidx ]; then
				break
			fi
			echo ""
			echo "Please give a valid number, 1 to $maxidx"
			echo ""
		done
		cp "${files[$fno]}" "$merged_arg"
	fi

	rm -rf $pfx
}

main()
{
	##
	## Simple, just invoke gvim with the arguments we were given
	##
	if [ $# -eq 2 ]; then
		diff "$1" "$2" >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			echo "Files are identical, skipping gvim"
			#exec "/usr/bin/xterm" -e "echo 'Files are identical, skipping gvim' && read -p 'Press enter to close' fno"
			exit 0
		fi
		do_gvim "$@"
		#do_diff "$@"
		exit 0
	fi

	##
	## If we got 4 arguments - we were given a merge to perform.
	## In this case, we launch a new terminal window to assist with deciding which file
	## is the result file - just in case multiple files were edited during the merging.
	##
	## The new terminal window just runs this same script with the same 4 arguments, but
	## with the addition of a new "cookie" argument that indicates "now its time for gvim"
	##
	if [ $# -eq 4 ]; then
		# These didn't work
		#exec "/usr/bin/gnome-terminal" -x "bash" -c "$0 vimdiffcookie \"$@\""
		#exec "/usr/bin/gnome-terminal" -e '/bin/sh' -c "$0" "vimdiffcookie" "$@"

		# This worked...
		# Needed to spell out each argument.  The "$@" construct didn't work here
		# where the entire -e argument must be surrounded in quotes, including the args
		#      i.e. -e "$0 vimdiffcookie \"$@\""
		#exec "/usr/bin/gnome-terminal" -e "$0 vimdiffcookie \"$1\" \"$2\" \"$3\" \"$4\""

		# This also worked, and this terminal window is ugly, yet going with this method
		# WHY: this method ensures that P4V displays a follow up message box
		#      asking:   "do you want to replace the merged file?"
		#
		#      i think because gnome terminal defers to and runs in a 'server'
		#      style process, that breaks the parent-child process relationship
		#      with the P4V process.
		exec "/usr/bin/xterm" -e "$0" "vimdiffcookie" "$@"
		exit 0
	fi

	##
	## Here we are performing a merge, and the terminal window has already been setup
	## So we call our "do_merge" helper function to prepare temp files for the merge.
	## When gvim closes, the temp files are examined and the edited one becomes the result
	##
	if [ $# -eq 5 ]; then
		do_merge "$@"
		exit 0
	fi

	echo "Error:  this script accepts only 2 (for diff) or 4 (for merge) arguments"
	exit -1
}

main "$@"

