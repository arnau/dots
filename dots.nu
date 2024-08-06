const my_config_allow_list = [
  bat
  carapace
  fish
  hammerspoon
  nushell
  tree-sitter
  vivid
  wezterm
]

def "nu-complete my-config-tools" [] {
  $my_config_allow_list
}

# Push configuration into the host.
export def "dots push" [tool: string@"nu-complete my-config-tools"] {
  let sink = match $tool {
    "hammerspoon" => $"($env.HOME)/.hammerspoon",
    "tree-sitter" => $"($env.HOME)/Library/Application Support/", 
    _ => $"($env.HOME)/.config/",
  }

  if $tool == "hammerspoon" {
    rm -rf $sink
  }

  cp -ru $"($env.HOME)/.dots/config/($tool)" $sink
}

# Pull configuration from the host.
export def "dots pull" [tool: string@"nu-complete my-config-tools"] {
  let source = match $tool {
    "hammerspoon" => $"($env.HOME)/.hammerspoon",
    "tree-sitter" => $"($env.HOME)/Library/Application Support/($tool)", 
    _ => $"($env.HOME)/.config/($tool)",
  }

  cp -ru $source $"($env.HOME)/.dots/config/" 
}

# Attempt to distribute files into the host. Use with extra care.
export def "dots bootstrap" [] {
  ln -s ~/.dots/zshrc ~/.zshrc
  cp -r ~/.dots/config/* ~/.config/
  mkdir ~/.cache/carapace
  carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
}  


# Structured help.
export def main [] {
  scope commands
  | where name =~ "^dots" | select name usage
}