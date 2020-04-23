if [ -n "$DOTFILES_DEBUG" ] && [ $TERM == "xterm-256color" ]; then
	echo "`date` + `whoami` + executing ${BASH_SOURCE[0]}"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function setdev {
	echo "booya kada!"
}

# Load the other dotfiles that initialize "non-inheritable" options/settings
for file in ~/.{aliases,functions,completions,options,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

