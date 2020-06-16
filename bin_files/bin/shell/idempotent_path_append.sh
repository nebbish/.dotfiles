##
## add_to_path:    an idempotent, almost shell-agnostic, method of updating the path
## from: https://unix.stackexchange.com/a/4973/194787
##
## Essentially - this script just skips the append if the path is already present
##               (also skips the append if the path is not valid ;)
##
add_to_path() {
	for d; do
		d=$({ cd -- "$d" && { pwd -P || pwd; } } 2>/dev/null) # canonicalize symbolic links
		if [ -z "$d" ]; then continue; fi # skip nonexistent directory
		case ":$PATH:" in
			*":$d:"*) :;;
			*) PATH=$PATH:$d;;
		esac
	done
}

#add_to_path ~/bin
#add_to_path ~/.local/bin

