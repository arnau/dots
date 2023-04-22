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

source "$HOME/.dots/zsh/aliases.zsh"
source "$HOME/.dots/zsh/docker.zsh"
source "$HOME/.dots/zsh/key-bindings.zsh"
source "$HOME/.dots/zsh/profile.zsh"
source "$HOME/.dots/zsh/prompt.zsh"

# tab multiplexer configuration: https://github.com/austinjones/tab-rs/
source "$HOME/Library/Application Support/tab/completion/zsh-history.zsh"
# end tab configuration

source "$HOME/.asdf/asdf.sh"

# Wasmer
export WASMER_DIR="/Users/arnau/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Created by `pipx` on 2022-12-25 08:54:00
export PATH="$PATH:$HOME/.local/bin"

# RTX (alt asdf)
_rtx_hook() {
  trap -- '' SIGINT;
  eval "$("$HOME/.cargo/bin/rtx" hook-env -s zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_rtx_hook]+1}" ]]; then
  precmd_functions=( _rtx_hook ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_rtx_hook]+1}" ]]; then
  chpwd_functions=( _rtx_hook ${chpwd_functions[@]} )
fi
