# This file is a stand-in replacement for my ".bashrc" file for VIM sub-shells
#
# * this file does not invoke the global in /etc...
# * this file does not load all of my own dotfiles
# * this file sets an EXTRA shell option:  to expand aliases
#
if [ -n "$DOTFILES_DEBUG" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
    echo "$(date) + $(whoami) + ${TERM} + executing $__source"
fi

# Load the other dotfiles that initialize "non-inheritable" options/settings
for file in ~/.{functions_bash,aliases_bash}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# This line is NOT here for normal flow, i.e. sourceing this file from ~/.bashrc
# but rather, for special cases like 'vim' that use this file through BASH_ENV
# (see ~/.vimrc for setting BASH_ENV - done via a 'let' command)
shopt -s expand_aliases


