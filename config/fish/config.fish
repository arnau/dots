if status is-interactive
    # Commands to run in interactive sessions can go here
    set -gx SHELL fish

    # Prompt
    starship init fish | source

    # Navigation
    eval "$(zoxide init fish)"

    # Fuzzy search
    fzf --fish | source
    # Skim
    export SKIM_DEFAULT_COMMAND='rg --color=always --files --hidden --follow --glob "!.git/*"'
    # sk --ansi -i -c 'rg --color=always --line-number "{}"'
end

function path_add --description "Prepends value if it doesn't exist"
    for item in $argv
        if not contains $item $PATH
            set PATH $item $PATH
        end
    end
end

alias vim=nvim
export EDITOR="hx"
export PAGER="less"

# Homebrew
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/lib"
export MANPATH="$MANPATH:/usr/local/man"
set BREW_PREFIX "$(brew --prefix)"

# Force nushell to look here instead.
export XDG_CONFIG_HOME="$HOME/.config"

# OpenSSL
set OPENSSL_PATH "$BREW_PREFIX/opt/openssl"
export OPENSSL_INCLUDE_DIR="$OPENSSL_PATH/include"
export OPENSSL_LIB_DIR="$OPENSSL_PATH/lib"

path_add /usr/local/bin /usr/local/sbin

# SQLite installed via brew
path_add "$BREW_PREFIX/opt/sqlite/bin"
set -gx LDFLAGS -L"$BREW_PREFIX/opt/sqlite/lib"
set -gx CPPFLAGS -I"$BREW_PREFIX/opt/sqlite/include"
set -gx PKG_CONFIG_PATH "$BREW_PREFIX/opt/sqlite/lib/pkgconfig"

# Rust
# source ~/.cargo/env
path_add "$HOME/.cargo/bin"

# Rye (Python)
# source ~/.rye/env
path_add "$HOME/.rye" "$HOME/.rye/shims"

# Luarocks
path_add "$HOME/.luarocks/bin"

# Local (e.g. hammerspoon cli)
path_add "$HOME/bin"
path_add "$HOME/.local/bin"
export MANPATH="$MANPATH:$HOME/.local/share/man"
