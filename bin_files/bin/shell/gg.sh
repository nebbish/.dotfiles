#!/bin/bash

#
# I was heavily experimenting with this code which came from this stackoverflow page:
#	http://stackoverflow.com/questions/4444547/using-single-vim-instance-with-remote-silent
#
# I also stumbled upon this page while trying to understand the "eval set --" syntax.  This page
# is an explanation of how to do it differently using arrays instead of strings:
#	http://stackoverflow.com/questions/35235707/bash-how-to-avoid-command-eval-set-evaluating-variables
#
# Also, while experimenting I used a 2nd bash shell to just experiment with the various
# techniques used in this script:
#	1) using getopt to produce a "cleaned up" list of arguments
#		(either as a string or an array)
#	2) using ARRAY+=('item') to append to an array (very different from ARRAY+='item')
#	3) using 'declare' to inspect the array contents
#		see: http://stackoverflow.com/questions/1951506/bash-add-value-to-array-without-specifying-a-key
#		for both of the above points.  GREAT article (i bookmarked it)
#

function resolveFile
{
    if [ -f "$1" ]; then
        echo $(readlink -f "$1")
    else
        echo "$1"
    fi
}

function gg
{
    local opts=$(getopt -o c: --long command: -n "gg" -- "$@")
	echo "opts:  $opts"
    if [ $? != 0 ]; then return 1; fi
    eval set -- "$opts"
	echo "after eval:  $@"
    cmd=""
	#cmd=()
    while :
    do
        case "$1" in
            -c|--command)
                #cmd="$2"
                cmd+="$2<cr>"
				#cmd+=("$2<cr>")
                shift 2
                ;;
            --) shift
                break
                ;;
        esac
    done
	#cmd="${cmd[@]}"
	echo "cmd after loop:  $cmd"
	echo "args after loop:  $@"

    if [[ -n "$cmd" ]]; then
        if [[ -n "${1-}" ]]; then
            #cmd=":e $(resolveFile $1)<cr>$cmd<cr>"
            cmd=":e $(resolveFile $1)<cr>$cmd"
        else
            #cmd="$cmd<cr>"
            cmd="$cmd"
        fi
        shift 1
    fi
    files=""
    for f in $@
    do
        files="$files $(resolveFile $f)"
    done
	echo "cmd:    $cmd"
	echo "files:  $files"
    cmd="$cmd:args! $files<cr>"
	echo "final cmd:    $cmd"
    #gvim --remote-send "$cmd"
}

gg "$@"

