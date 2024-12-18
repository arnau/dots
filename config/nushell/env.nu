# Nushell Environment Config File

$env.STARSHIP_SHELL = "nu"

$env.PROMPT_COMMAND = {|| (starship prompt | lines | get 1 | $in + "\n\n") }
$env.TRANSIENT_PROMPT_COMMAND = ""
$env.PROMPT_COMMAND_RIGHT = ""

$env.PROMPT_INDICATOR = ""
# $env.PROMPT_INDICATOR_VI_INSERT = {|| "·  " }
# $env.PROMPT_INDICATOR_VI_NORMAL = {|| "·· " }
# $env.PROMPT_MULTILINE_INDICATOR = {|| ":: " }
$env.PROMPT_INDICATOR_VI_INSERT = {||
    let colour = if ($env.LAST_EXIT_CODE == 1) { ansi red } else { ansi grey }

    $"($colour)(ansi reset)  " 
}
$env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi yellow)(ansi reset)  " }
$env.PROMPT_MULTILINE_INDICATOR = {|| $"(ansi blue_bold)(ansi reset)  " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.EDITOR = "hx"
$env.VISUAL = "hx"

#start:me
$env.KITCHEN_HOME = ($env.HOME | path join "kitchen")
#end:me

#start:home
$env.HOME_CACHE = ($env.HOME | path join ".cache")
$env.HOME_CONFIG = ($env.HOME | path join ".config")
#end:home

#start:macos_apps
$env.BOOKS_HOME = $"($env.HOME)/Library/Containers/com.apple.iBooksX/Data/Documents"
$env.FIREFOX_HOME = $"($env.HOME)/Library/Application Support/Firefox/Profiles/ynmd11dc.default-release"
$env.HOME_LIB = ($env.HOME | path join "Library/Application Support")
#end:macos_apps

# start:external_tools
$env.RYE_HOME = ($env.HOME | path join ".rye")

$env.GITHUB_TOKEN_OP = "op://Private/github_token/token"

$env.JIRA_TOKEN_OP = "op://Private/seachess_jira_token/credential"
$env.JIRA_USERNAME_OP = "op://Private/erdzhl2pumptm5lzovftkldqeq/username"
$env.JIRA_BASEURL_OP = "op://Private/seachess_jira_token/hostname"
# end:external_tools

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts

    # pit module
    ($env.KITCHEN_HOME | path join "pit")
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

export use std
