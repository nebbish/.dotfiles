#export DOTFILES_DEBUG=1
if [ -n "$DOTFILES_DEBUG" ] && [ "${TERM##*-}" = "256color" ]; then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
	echo "$TERM + $(date) + $(whoami) + executing $__source"
fi

