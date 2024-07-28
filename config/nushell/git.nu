# nuified `git status -s`
def "gut status" [
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
  | update x { gut _style-status $expand_labels }
  | update y { gut _style-status $expand_labels }
}

def "gut remote list" [] {
  ^git remote --verbose
  | lines
  | parse --regex '^(?P<name>[^\s]+)\s+(?P<url>[^\s]+)\s+\((?P<action>.+)\)$'
}

def "gut remote show" [name: string@"nu-complete git_remote_list" = "origin"] {
  ^git remote show $name
}

def "gut reflog" [] {
  ^git reflog --pretty='{commit_hash: "%h", ref_names: [%(decorate:prefix=,suffix=,pointer=>)], subject: "%s", reflog: "%gd"}'
  | lines -s
  | each { from nuon }
}

def --wrapped "gut log" [--help (-h), ...rest] {
  if $help { return (help gut log) }

  ^git log --pretty='{commit_hash: "%h", author: {name: "%an", email: "%ae", date: "%aI"}, committer: {name: "%cn", email: "%ce", date: "%cI"}, ref_names: [%(decorate:prefix=,suffix=,pointer=>)], subject: "%s"}' ...$rest
  | lines -s
  | each { from nuon }
}

def --wrapped "gut ls" [--help (-h), ...rest] {
  if $help { return (help gut log) }

  ^git ls-files ...$rest
  | lines
}

def "nu-complete git_remote_list" [] {
  ^git remote | lines | str trim 
}

def "gut _style-status" [e: bool] {
  let status = $in
  if $e {
    $status | gut _expand-status
  } else { 
    match $status {
      " " => $"($status | gut _status-colour).(ansi reset)"
      _ => $"($status | gut _status-colour)($status)(ansi reset)"
    }
  }
}

def "gut _expand-status" [] {
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

  $"($status | gut _status-colour)($label)(ansi reset)"
}

def "gut _status-colour" [] {
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
