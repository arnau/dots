LOCAL_PATH="$HOME/bin"

export EDITOR="nvim"
export PAGER="less"

export PATH="$LOCAL_PATH:$PATH"

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

# Skim
export SKIM_DEFAULT_COMMAND='rg --color=always --files --hidden --follow --glob "!.git/*"'
# sk --ansi -i -c 'rg --color=always --line-number "{}"'

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer
