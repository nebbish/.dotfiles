if [ -n "$DOTFILES_DEBUG" ];then
	if [ -n "$ZSH_VERSION" ]; then
		__source="${(%):-%x}"
	else
		__source="${BASH_SOURCE[0]}"
	fi
    echo "$(date) + $(whoami) + ${TERM} + executing $__source"
fi

