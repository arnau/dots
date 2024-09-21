setopt NO_CASE_GLOB
setopt GLOB_COMPLETE
setopt CORRECT
setopt interactivecomments
bindkey "^Q" push-input

# Rebuild index
#
# % rm -f ~/.zcompdump
# % compinit
#
fpath+=~/.config/zfunc
autoload -Uz compinit
compinit

alias vim=nvim

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export EDITOR="hx"
export PAGER="less"
