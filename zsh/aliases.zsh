alias vim=nvim
alias scannet='arp -i en0 -a'
alias pasifae='PASSWORD_STORE_DIR=~/pasifae/.pasifae-store pass'
alias snip='tldr $(tldr --list | tr , "\n" | sk)'
alias skpid="ps -ef | sed 1d | sk -m --header='[pid:process]' | awk '{print \$2}'"
