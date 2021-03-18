if [ -n "$DOTFILES_DEBUG" ] && [ "${TERM##*-}" = "256color" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
	echo "$(date) + $(whoami) + executing $__source"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Load the other dotfiles that initialize "non-inheritable" options/settings
for file in ~/.{functions_bash,aliases_bash,completions_bash,options_bash,extra_bash}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

