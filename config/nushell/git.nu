# nuified `git status -s`
def "git status" [
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
  | update x { git _style-status $expand_labels }
  | update y { git _style-status $expand_labels }
}
alias "git s" = git status

def "git remote list" [] {
  ^git remote --verbose
  | lines
  | parse --regex '^(?P<name>[^\s]+)\s+(?P<url>[^\s]+)\s+\((?P<action>.+)\)$'
}

def "git remote show" [name: string@"nu-complete git_remote_list" = "origin"] {
  ^git remote show $name
}

def "git reflog" [] {
  ^git reflog --pretty='{commit_hash: "%h", ref_names: [%(decorate:prefix=,suffix=,pointer=>)], subject: "%s", reflog: "%gd"}'
  | lines -s
  | each { from nuon }
}


def --wrapped "git log" [
  --help (-h),
  --slim (-s)
  ...rest
] {
  if $help { return (help git log) }

  const template = "%h\t{name: \"%an\", email: \"%ae\", date: \"%as\"}\t{name: \"%cn\", email: \"%ce\", date: \"%cI\"}\t[%(decorate:prefix=,suffix=,pointer=>)]\t%s"
  const columns = [hash author committer refs subject]

  ^git log --pretty=($template) ...$rest
  | from csv -s "\t" -n
  | rename ...$columns
  | update author { from nuon }
  | update committer { from nuon }
  | update refs { from nuon }
  | if ($slim) {
      select hash author.date author.email refs subject
    } else { $in }

}

alias "git l" = git log -s

# Last log record
def "git last" [] {
    git log -1 | get 0
}


def --wrapped "git ls" [--help (-h), ...rest] {
  if $help { return (help git ls) }

  ^git ls-files ...$rest
  | lines
}

def "nu-complete git_remote_list" [] {
  ^git remote | lines | str trim 
}

def "git _style-status" [e: bool] {
  let status = $in
  if $e {
    $status | git _expand-status
  } else { 
    match $status {
      " " => $"($status | git _status-colour).(ansi reset)"
      _ => $"($status | git _status-colour)($status)(ansi reset)"
    }
  }
}

def "git _expand-status" [] {
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

  $"($status | git _status-colour)($label)(ansi reset)"
}

def "git _status-colour" [] {
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


# Slurps changes for the given paths into the last commit.
def "git slurp" [
  --signoff (-s) # Add a Signed-off-by trailer by the committer at the end of the commit log message.
  --gpg-sign (-S) # Sign commit with the default keyid.
  ...paths
] {
  let flags = [
    {flag: "--signoff", value: $signoff}
    {flag: "--gpg-sign", value: $gpg_sign}
    {flag: "--amend", value: true}
    {flag: "--no-edit", value: true}
  ]

  if ($paths | is-empty) {
    error make { msg: "You must pass at least one path to be added." }
  }

  let options = $flags | where value != false | get flag

  ^git commit ...$options ...$paths
}
