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
    # pkgs.neovim
    # pkgs.luajitPackages.luv
    pkgs.bat                 # cat replacement.
    pkgs.devd
    pkgs.direnv
    pkgs.dos2unix            # handle line breaks from DOS.
    pkgs.editorconfig-core-c # configure editor per project.
    pkgs.exa                 # ls replacement.
    pkgs.fd                  # find replacement.
    pkgs.fossil              # sqlite-based VCS.
    pkgs.git                 # main VCS.
    pkgs.gnused              # macos sed is ancient.
    pkgs.jq                  # operate on JSON.
    pkgs.mercurial           # another VCS.
    pkgs.pandoc              # transform document formats.
    pkgs.pass                # manage passwords.
    pkgs.ripgrep             # grep replacement.
    pkgs.skim                # fuzzy finder.
    pkgs.tealdeer            # man replacement.
    pkgs.time                # macos time is ancient.
    pkgs.tokei               # count code.
    pkgs.xsv                 # operate on CSV, TSV.
  ];
  experimental = [
    #pkgs.pijul
    #pkgs.racket
    #pkgs.swiProlog
  ];

  # The full list of inputs to install
  inputs = stable ++ experimental;
in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    {
      buildInputs = inputs;
      shellHook = ''
        set -o vi
        local pink='\e[1;35m'
        local yellow='\e[1;33m'
        local blue='\e[1;36m'
        local white='\e[0;37m'
        local reset='\e[0m'

        git_branch() {
          git rev-parse --abbrev-ref HEAD 2>/dev/null
        }

        export PS1="\[$pink\]nix \[$blue\]\W \[$yellow\]\$(git_branch)\[$white\] ∙ \[$reset\]"

        alias ls=exa
      '';
    }
  else
    inputs
