# My set of helpers

# Hack to hide private helpers when module is loaded via `source`.
module _my {
  # Use `date to-weeknumber`.
  export def to-weeknumber [] {
      $in | format date "%V" | into int
  }
}

use _my

# Sums a list of filesizes
#
# ```
# ls **/*.pdf | get size | filesize sum
# ```
export def "filesize sum" []: [list<filesize> -> filesize] {
    $in | reduce {|it, acc| $it + $acc }
}


# Convert text or datetime into weeknumber.
#
# ```nushell
# "2024-08-05" | date to-weeknumber
# ```
export def "date to-weeknumber" [
    --format (-f): string # Specify expected format of INPUT string to parse datetime
]: [string -> int, datetime -> int, list<string> -> list<int>, int -> int, list<int> -> list<int>] {
    let input = $in

    match ($input | describe) {
        "string" | "list<string>" => {
            $input | into datetime | _my to-weeknumber
        },
        "int" | "list<int>" => {
            $input | into datetime | _my to-weeknumber
        },
        "date" => {
            $input | _my to-weeknumber
        },
    }
}


# Like `describe` but dropping item types for collections.
export def describe-primitive []: any -> string {
  $in | describe | str replace --regex '<.*' ''
}


# Displays today as a date record extended with week.
export def today []: [nothing -> record] {
    let stamp = date now

    $stamp
    | date to-record
    | insert weeknumber { $stamp | _my to-weeknumber }
    | insert weekday { $stamp | format date "%A" }
    | insert timestamp { $stamp | format date "%s" | into int | $in * 1_000_000_000 }
    | reject nanosecond
}


# A thin wrapper over DuckDB.
#
# REQUIREMENTS: duckdb
export module ddb {
  # Executes the given command against the given database.
  #
  # ```
  # ddb run "select * from 'foo.parquet'"
  # ddb run "copy tbl from 'foo.parquet'" mydb.duckdb
  # ```
  export def run [
    command: string  # The query to run.
    filename: string = "" # The filename of the DuckDB database to use.
    --bail # Stop after hitting an error.
  ] {
    let flags = [
      {flag: "-bail", value: $bail}
    ]

    let options = $flags | where value == true | get flag | str join ' '

    ^duckdb $options -jsonlines -c $command  $filename
    | lines
    | each { from json }
  }


  # Shows the DuckDB version
  export def version [] {
    ^duckdb -version
  }

  # Starts an interactive shell with the given DuckDb database opened.
  #
  # ```
  # ddb shell
  # ddb shell mydb.duckdb
  # ```
  export def shell [
    filename: string = "" # The filename of the DuckDB database to use.
  ] {
    ^duckdb $filename
  }

  # Show the list of available commands in the module.
  export def main [] {
    scope commands | where name =~ "ddb"
  }
}
