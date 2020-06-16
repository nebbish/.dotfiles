if [ -n "$DOTFILES_DEBUG" ] && [ "${TERM##*-}" = "256color" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
	echo "$(date) + $(whoami) + executing $__source"
fi

##
## NOTE:  A great explanation of login vs non-login shells included great explanation of what
##        should go in the ".bash_profile" startup file, vs the ".bashrc" startup file.
##               https://unix.stackexchange.com/questions/324359/why-a-login-shell-over-a-non-login-shello
##                      --or--
##               https://unix.stackexchange.com/a/324391/194787
##
##        Based on that answer, this file should limit itself to "inheritable" settings
##        And the ".bashrc" file will sett all NON-inheritable options
##

# Load the other dotfiles that initialize "inheritable" options/settings
for file in ~/.{path_bash,prompt_bash,exports_bash}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Bash will not automatically load *both* startup files, so we do it here
if [ -f ~/.bashrc ]; then
	. ~/.bashrc;
fi;

