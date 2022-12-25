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

if hash kitty 2>/dev/null; then
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin
fi

source "$HOME/.dots/zsh/aliases.zsh"
source "$HOME/.dots/zsh/docker.zsh"
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
export PATH="$PATH:/Users/arnau/.local/bin"
