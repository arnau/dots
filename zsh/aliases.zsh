alias ls=exa
alias tree='exa -Tl'
alias scannet='arp -i en0 -a'
alias serve='devd .'
# alias serve='python -m SimpleHTTPServer'
# alias gpg='gpg2'
alias pasifae='PASSWORD_STORE_DIR=~/pasifae/.pasifae-store pass'
alias snip='tldr $(tldr --list | tr , "\n" | sk)'
alias skpid="ps -ef | sed 1d | sk -m --header='[pid:process]' | awk '{print \$2}'"

function lf() {
  ls "$1" | sk
}
