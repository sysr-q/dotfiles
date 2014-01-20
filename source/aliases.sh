alias vi="vim"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias ll="ls -l"
alias wtc="curl -s http://whatthecommit.com/index.txt"

function make() {
	if [[ "$@" == "me a sandwich" ]]; then
		echo "What? Make it yourself!"
		return 1
	else
		\make "$@"
		return $?
	fi
}
