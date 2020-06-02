setopt PROMPT_SUBST
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats '%F{magenta}%a%f '
zstyle ':vcs_info:*' formats '%F{yellow}%b '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git fossil hg

precmd() {
  vcs_info
}

PS1='%B%F{blue}%1~%f ${vcs_info_msg_0_}%(?.%F{white}∙.%F{red}%??)%f%b '
