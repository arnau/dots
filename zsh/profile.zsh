LOCAL_PATH="$HOME/bin"

export EDITOR="nvim"
export PAGER="less"

# OpenSSL
OPENSSL_PATH="/usr/local/opt/openssl"
export OPENSSL_INCLUDE_DIR="$OPENSSL_PATH/include"
export OPENSSL_LIB_DIR="$OPENSSL_PATH/lib"

# Homebrew
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/lib"
export PATH="$PATH:/usr/local/bin:/usr/local/sbin"
export MANPATH="$MANPATH:/usr/local/man"

# Haskell, Idris
export PATH="$PATH:$HOME/.cabal/bin"

# SQLite installed via brew
export PATH="/usr/local/opt/sqlite/bin:$PATH"


# Rust
source ~/.cargo/env

# Grep
[ -d /usr/local/opt/grep/libexec/gnubin ] && PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
