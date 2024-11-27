#export DOTFILES_DEBUG=1
if [ -n "$DOTFILES_DEBUG" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
    echo "$(date) + $(whoami) + ${TERM} + executing $__source"
fi

# Load the other dotfiles that initialize "inheritable" options/settings
for file in ~/.{path_zsh,prompt_zsh,exports_zsh}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

