alias vi="vim"
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias ll="ls -l"
alias wtc="curl -s http://whatthecommit.com/index.txt"

function sprunge() {
	data=$(cat $*)
	url=$(curl -F "sprunge=$data" http://sprunge.us 2>/dev/null)
	echo $url
	echo $url | xclip
}

function expose-remote() {
	# expose-remote <host> <remote-port> <local-port>
	ssh -N -R $2:localhost:$3 $1
}

