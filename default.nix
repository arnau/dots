with (import <nixpkgs> {});

{
  inherit
    ## Brew

    # bash_5
    # git
    # fzf
    # tmux
    # opam
    # vim
    # openssl

    ## Stable

    direnv
    dos2unix
    editorconfig-core-c
    fd
    fossil
    jq
    mercurial
    neovim
    pandoc
    pass
    ripgrep
    tokei
    xsv

    ## Experimental

    pijul
    #racket
    swiProlog
  ;
}
