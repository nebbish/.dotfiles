# This file is a VIM-only replacement for ".zshenv", used for VIM sub-shells
#

# My main .zshenv file does nothing really - the Z-shell's interactive shells
# handle loading the rest of Z-shell's startup files.   For NON-interactive
# shells however - just .zshenv gets loaded.
#
# I have configured my VIMRC to set the ZDOTDIR environment variable so that
# when VIM launches a shell the .zshenv from the VIM files area will be used.
#
#export DOTFILES_DEBUG=1
if [ -n "$DOTFILES_DEBUG" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
	echo "$(date) + $(whoami) + ${TERM} + executing $__source"
fi

##
## There are two typical ways of checking for interactive:
##   * if $- contains an 'i'     <-- documented, we choose this
##   * if $PS1 contains a value
##
case "$-" in
	*i*)
		# The shell IS interactive - redirect to HOME to load the rest
        if [ -n "$DOTFILES_DEBUG" ]; then
            echo "This shell IS interactive"
        fi
		export ZDOTDIR=~
		;;
	*)
		# The shell is NON-interactive, manually load functions & aliases
        if [ -n "$DOTFILES_DEBUG" ]; then
            echo "This shell is NOT interactive"
        fi
		for file in ~/.{functions_zsh,aliases_zsh}; do
			[ -r "$file" ] && [ -f "$file" ] && source "$file";
		done;
		unset file;
		;;
esac

