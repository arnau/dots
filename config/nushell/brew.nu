
def "brew info" []: [list<string> -> table] {
  let packages = (^brew info -q --json=v2 ...($in) | from json)

  let formulae = ($packages.formulae | select full_name desc | rename name summary)
  let casks = ($packages.casks | select full_token desc | rename name summary)

  $formulae | append $casks
}

# Dumps the list of taps, formulae and casks pulling in their description.
def "brew dump" [] {
  let brewfile = ^brew bundle dump -q --file=- | lines | parse "{type} \"{name}\""

  $brewfile
  | join -l ($brewfile | where type != "tap" | get name | brew info) name
}
