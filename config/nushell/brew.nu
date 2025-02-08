
def "infuse info" []: [list<string> -> table] {
  let packages = (^brew info -q --json=v2 ...($in) | from json)

  let formulae = ($packages.formulae | select full_name desc | rename name summary)
  let casks = ($packages.casks | select full_token desc | rename name summary)

  $formulae | append $casks
}

# Dumps the list of taps, formulae and casks pulling in their description.
def "infuse dump" [] {
  let brewfile = ^brew bundle dump -q --file=- | lines | parse "{type} \"{name}\""

  $brewfile
  | join -l ($brewfile | where type != "tap" | get name | brew info) name
}

# Generates a Brewfile from a catalogue file.
#
# ```nushell
# open catalogue/brew.csv | brew assemble | save Brewfile
# ```
def "infuse assemble" [] {
  $in
  | select type name
  | each { |row| $"($row.type) ($row.name)" }
  | str join "\n"
}
