# nuified `git status -s`
def "git nu status" [
  --untracked (-u): string = "normal" # Show untracked files. {no, normal, all}
  --ignored (-i): string = "no" # Show ignored files. {traditional, no, matching}
  --expand-labels (-e) # Expands symbols to labels.
  ...rest
] {
  ^git status -s --porcelain=v1 --untracked-files=($untracked) --ignored=($ignored) ...$rest
  | lines
  | parse --regex '^(?P<x>.)(?P<y>.)\s+(?:(?P<old_name>.+?(?=\s->\s))\s->\s)?(?P<name>.+)$'
  | update name {
      let name = $in
      if ($name | str ends-with "/") {
        $"(ansi cyan_bold)($name | str trim --right --char "/")(ansi reset)"
      } else {
        $name
      }
    }
  | update x { style-status $expand_labels }
  | update y { style-status $expand_labels }
}

def style-status [e: bool] {
  let status = $in
  if $e {
    $status | expand-status
  } else { 
    match $status {
      " " => $"($status | status-colour).(ansi reset)"
      _ => $"($status | status-colour)($status)(ansi reset)"
    }
  }
}

def expand-status [] {
  let status = $in
  let label = match $status {
    " " => "unmodified"
    "!" => "ignored"
    "?" => "untracked"
    "A" => "added"
    "D" => "deleted"
    "C" => "copied"
    "M" => "modified"
    "m" => modified
    "R" => "renamed"
    "T" => "type changed"
    "U" => "updated"
  }

  $"($status | status-colour)($label)(ansi reset)"
}

def status-colour [] {
  let status = $in
  match $status {
    " " => (ansi white_bold)
    "!" => (ansi yellow)
    "?" => (ansi red)
    "A" => (ansi green)
    "D" => (ansi red_bold)
    "C" => (ansi magenta)
    "M" => (ansi cyan)
    "m" => (ansi cyan)
    "R" => (ansi blue)
    "T" => (ansi purple)
    "U" => (ansi blue)
    _ => (ansi white)
  }
}

alias "gun st" = git nu status
