if [ -n "$DOTFILES_DEBUG" ] && [ "${TERM##*-}" = "256color" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
	echo "$(date) + $(whoami) + executing $__source"
fi

# Load the other dotfiles that initialize "inheritable" options/settings
for file in ~/.{functions_zsh,aliases_zsh,completions_zsh,options_zsh,extra_zsh}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

