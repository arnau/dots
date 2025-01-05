# This module implements a set of commands for interacting with the «Diccionari de la llengua catalana de l'Institut d'Estudis Catalans».
# WARN: This module requires the `nu_plugin_query` to be installed.


const user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:133.0) Gecko/20100101 Firefox/133.0"
const content_type = "application/x-www-form-urlencoded;charset=UTF-8"


## Commands ####################################################################

 
# Looks up a Catalan term either exact or by partial matching.
#
# WARN: It attempts to return all definitions for all term variants found which, for partial matches, can go as high as 1000.
export def search [
    term: string                                     # term to search
    --match (-m): string@"matching_criteria" = exact # matching criteria
] {
    fetch term $term --match $match
    | par-each {|row|
        $row
        | insert definitions { (fetch definition $row.id | strip-html | reject raw_content) }
      }
}

# Looks up a Catalan term either exact or by partial matching.
# 
# WARN: It attempts to return all definitions for all term variants found which, for partial matches, can go as high as 1000.
export def "fetch term" [
    term: string                                     # term to search
    --match (-m): string@"matching_criteria" = exact # matching criteria
    --raw                                            # returns the full HTML response instead of the extracted data.
] {
    let criteria = matching_criteria_id $match
    let params = {
        DecEntradaText: $"($term)"
        OperEntrada: $"($criteria)"
    }
    let url = build-url Results $params
    let headers = {
        "User-Agent": $user_agent
        "Content-Type": $content_type
    }

    let response = http get --headers $headers $url

    if ($raw) {
        $response
    } else {
        $response | extract
    }
}

# Fetches the definition for a given term variant identifier.
#
# See `fetch term` and `extract`.
export def "fetch definition" [id: string] {
    let url = build-url "Results/Accepcio"
    let headers = {
        "User-Agent": $user_agent
        "Content-Type": $content_type
    }

    let data = {
        "id": $"($id)"
    }

    http post --headers $headers $url ($data | url build-query)
}


# Extracts id and text from the result HTML for each term variant found during a search.
export def extract [] {
    let html = $in

    let ids = $html
        | query web --query ".resultText > a" --attribute [id]
    let text = $html
        | query web --query ".resultText > a"
        | each {|row| {content: ($row | to text | str trim)}}

    $ids | merge $text
}



## Helpers ####################################################################

# Builds a DIEC url.
export def build-url [path: string, params: record = {}] {
    let url = {
        "scheme": "https",
        "host": "dlc.iec.cat",
        "path": $path,
        "params": $params
    }

    $url | url join
}

# Blunt implementation for removing all HTML/XML tags from a given text.
export def strip-html [] {
    # $in | insert text {|row| $row.content | parse --regex '</?[^>]+>([^<]+)' | get capture0 | str join " " }
 
    $in
    | insert raw_content {|row| $row.content }
    | update content {
          $in
          | split row --regex '<br[^>]+>'
          | each { parse --regex '^<span class="body"[^>]+><B>(?<ordinal>[^<]+)</B>\s*(?:<I>(?<sub_ordinal>[^<]+)</I>)?</span>\s*(?:<span class="tagline"[^>]+>(?<tagline>[^<]+)</span>)?\s*(?:<span class="body"[^>]+>\s*<span class="tip"[^>]+>\s*(?<tip>[^<]+)\s*</span>\s*</span>)?\s*(?:<span class="versaletaIT"[^>]+>[^<]+</span>)?\s*(?:<span class="body"[^>]+>(?:<span class="bolditalic">\s*(?<locution>[^<]+)\s*</span>)?(?:(?<definition>(?:<I>[^<]+</I>\s*)?[^<]+))?(?:(?<examples>.+))?</span>)' }
          | flatten
          | update examples {
                str replace -a -r '^</span>' ''
                | str replace -a '</span></span>' '</span>'
                | str replace -a -r '<span class="body"[^>]+>' ''
                | parse --regex '<span class="italic">(?<item>[^<]+)</span>'
                | get item
            }
          | each {|row|
                let tmp = $row.definition | parse --regex '(?:<I>(?<tagline>[^<]+)</I>)?(?<def>.+)'

                $row
                | update definition { $tmp.def.0? }
                | update tagline { if ($tmp.tagline.0? | is-not-empty) { $tmp.tagline.0 } else { $row.tagline } }
            }
      }
    | flatten --all
}


# The list of matching criteria for searches.
def matching_criteria [] {
    [
        exact
        start
        end
        any
        not_start
        not_end
        not
    ]
}

# Helper to map criterion to a numeric id.
def matching_criteria_id [criterion: string@matching_criteria] {
    matching_criteria
    | enumerate
    | where item == $criterion
    | get index
    | to text
    | str trim
}
