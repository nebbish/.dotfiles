#
# Can be run with BASH or ZSH...    which is the point of this script - everything it does it does for both
#

##
## Detect shell type ('bash' or 'zsh')
## (got this from: https://unix.stackexchange.com/a/72475/194787)
##
##
## Then, based on shell - get current script name & directory
## (zsh part:       https://stackoverflow.com/a/28336473/5844631)
## (readlink part:  https://stackoverflow.com/a/35374073/5844631)
##
if [ -n "$ZSH_VERSION" ]; then
	echo "Detected ZSH"
	__source="${(%):-%x}"
elif [ -n "$BASH_VERSION" ]; then
	echo "Detected BASH"
	__source="${BASH_SOURCE[0]}"

	# From:  https://www.gnu.org/software/bash/manual/bash.html#Is-this-Shell-Interactive_003f
	case "$-" in
		*i*) __interactive=1
		*)   __interactive=0
	esac
	# same source, alternative method:
	if [ -z "$PS1" ]; then
		__alt_interactive=0
	else
		__alt_interactive=1
	fi
else
	echo "Unknown shell"
	__source="unknown"
fi

##
## Then get the dir & title of the current script
##
echo "$(date) + $(whoami) + executing $__source"
__dir="$(dirname "$__source")"
__source="$(basename "$__source")"
echo "Running from: [$__dir]"



##
## Detect OS
##
if [ "$OSTYPE" = "linux-gnu" ]; then
	echo "Detected:   linux    ($OSTYPE)"
elif [ "${OSTYPE:0:6}" = "darwin" ]; then
	echo "Detected:  darwin    ($OSTYPE)"
elif [ "$OSTYPE" = "cygwin" ]; then
	echo "Detected:  cygwin    ($OSTYPE)"
elif [ "$OSTYPE" = "msys" ]; then
	echo "Detected:    msys    ($OSTYPE)"
elif [ "$OSTYPE" = "win32" ]; then
	echo "Detected:   win32    ($OSTYPE)"
elif [ "${OSTYPE:0:7}" = "freebsd" ]; then
	echo "Detected: freebsd    ($OSTYPE)"
fi

##
## Detect terminal type (i.e. $TERM)
##
if [ "${TERM%%-*}" = "xterm" ]; then
	echo "Detected 'xterm' type terminal"
elif [ "${TERM%%-*}" = "screen" ]; then
	echo "Detected 'screen' or 'tmux' type terminal"
elif [ "${TERM%%-*}" = "tty" ]; then
	echo "Detected 'teltype' type terminal"
fi

