if [ -n "$DOTFILES_DEBUG" ] && [ $TERM == "xterm-256color" ]; then
	echo "`date` + `whoami` + executing ${BASH_SOURCE[0]}"
fi;

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

# Setup ~/bin and ~/.local/bin to the $PATH value (the 2nd location hosts decrypted private files)
PATH=$HOME/bin:$PATH:$HOME/.local/bin;
export PATH;

# Load the other dotfiles that initialize "inheritable" options/settings
for file in ~/.{path,bash_prompt,exports}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Bash will not automatically load *both* startup files, so we do it here
if [ -f ~/.bashrc ]; then
	. ~/.bashrc;
fi;

