hammerspoon-in:
  cp -R ~/.hammerspoon/* hammerspoon/

hammerspoon-out:
  cp -R hammerspoon/* ~/.hammerspoon/

setup:
  ln -s ~/.dots/zshrc ~/.zshrc
  # cp -R ~/.dots/config/alacritty ~/.config/
  # cp -R ~/.dots/config/kitty ~/.config/

nushell-in:
  cp -R ~/Library/Application\ Support/nushell/* nushell/

nushell-out:
  cp -R nushell/* ~/Library/Application\ Support/nushell/

wezterm-in:
  cp -R ~/.config/wezterm config/

wezterm-out:
  cp -R config/wezterm ~/.config/

helix-in:
  cp -R ~/.config/helix config/

helix-out:
  cp -R helix ~/.config/


carapace:
  mkdir ~/.cache/carapace
  carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
  #~/.config/nushell/config.nu
  # source ~/.cache/carapace/init.nu

tree-sitter-in:
  cp -R ~/Library/Application\ Support/tree-sitter/

tree-sitter-out:
  cp -R tree-sitter/* ~/Library/Application\ Support/tree-sitter/

