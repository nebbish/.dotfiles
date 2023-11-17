if [ -n "$DOTFILES_DEBUG" ] && [ "${TERM##*-}" = "256color" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
	echo "$(date) + $(whoami) + executing $__source"
fi


if [ "${OSTYPE:0:5}" = "linux" ]; then
    if [ -x "$(which lsb_release 2>/dev/null)" ]; then
        osnick=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        osnick=$ID
    else
        osnick=$(uname -s)
    fi
elif [ "${OSTYPE:0:6}" = "darwin" ]; then
    osnick='darwin'
fi

# Now that we know the OS -- source my static copy of some version of that OS's default RC file:
case $osnick in
    ubuntu ) . ~/.bashrc_ubuntu22 ;;
    centos ) . ~/.bashrc_centos7 ;;
esac

# Load the other dotfiles that initialize "non-inheritable" options/settings
for file in ~/.{functions_bash,aliases_bash,completions_bash,options_bash,extra_bash}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
