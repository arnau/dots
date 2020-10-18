setopt NO_CASE_GLOB
setopt GLOB_COMPLETE
setopt CORRECT

# Rebuild index
#
# % rm -f ~/.zcompdump
# % compinit
#
autoload -Uz compinit
compinit
exists() { [ ! -z `which "$1"` ]; }

if exists kitty; then
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin
fi

source "$HOME/.dots/zsh/aliases.zsh"
source "$HOME/.dots/zsh/docker.zsh"
source "$HOME/.dots/zsh/profile.zsh"
source "$HOME/.dots/zsh/prompt.zsh"