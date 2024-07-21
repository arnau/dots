## Convenience wrapper for [Cargo](https://doc.rust-lang.org/stable/cargo/)


# Lists the cargo sub-commands.
def "cargo commands" [] {
    ^cargo --list
    | lines -s
    | skip 1
    | str trim
    | split column --regex '\s\s+'
    | rename name summary
}



# Transforms the raw cargo install-update output into a nushell table.
def "cargo packages parse" [] {
    $in
    | lines -s
    | where $it !~ "^$"
    | skip 1
    | collect
    | split column --regex '\s\s+(\([^\)]\))?'
    | headers
    | rename package current_version latest_version is_latest
    | where is_latest? != null
    | update is_latest { $in == "Yes" }   
}

# Displays the list of installed packages.
#
# Packages are installed with `cargo-update`.
def "cargo packages list" [...packages] {
    ^cargo install-update --list ...$packages
    | cargo packages parse
}

# Displays the list of installed packages.
#
# Packages are installed with `cargo-update`.
def "cargo packages" [...packages] {
    cargo packages list ...$packages
}
# Displays the list of installed packages that need updating.
def "cargo packages outdated" [...packages] {
    cargo packages ...$packages
    | where "Needs update"
}

# Updates the list of binaries installed with cargo.
def "cargo packages update" [...packages] {
    let all_or_some = if ($packages | is-empty) { --all } else { $packages }

    ^cargo install-update $all_or_some
    | cargo packages parse
}
