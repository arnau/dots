let
  pkgs = import <nixpkgs> {};
  # brew = [
  #   # bash_5
  #   # git
  #   # fzf
  #   # tmux
  #   # opam
  #   # vim
  #   # openssl
  # ];
  stable = [
    pkgs.direnv
    pkgs.dos2unix
    pkgs.editorconfig-core-c
    pkgs.fd
    pkgs.fossil
    pkgs.gnused
    pkgs.jq
    pkgs.luajit
    pkgs.mercurial
    # pkgs.neovim-unwrapped
    # pkgs.neovim
    pkgs.pandoc
    pkgs.pass
    pkgs.ripgrep
    pkgs.tokei
    pkgs.xsv
  ];
  experimental = [
    #pkgs.pijul
    #pkgs.racket
    #pkgs.swiProlog
    pkgs.tealdeer
    pkgs.time
  ];
in
  stable ++ experimental
