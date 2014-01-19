function git-current-branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo ${ref#refs/heads/}
}

function git-current-repository() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo $(git remote -v | cut -d':' -f 2)
}

function git-is-dirty() {
	return $(git status --porcelain | wc -l)
}

function git-is-ahead() {
	brinfo=$(git branch -v | grep $(git-current-branch))
	return $(echo "$brinfo" | egrep "\[ahead ([[:digit:]]*)\]" | wc -l)
}
