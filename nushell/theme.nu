export def main [] {
  let theme = {
      # color for nushell primitives
      separator: white
      leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
      header: white
      empty: blue
      bool: light_cyan
      int: purple
      filesize: cyan
      duration: purple
      date: purple
      range: purple
      float: purple
      string: white
      nothing: white
      binary: white
      cellpath: white
      row_index: "#fff0f5"
      record: white
      list: white
      block: white
      hints: dark_gray
      search_result: {bg: red fg: white}    
      shape_and: purple
      shape_binary: purple
      shape_block: blue_bold
      shape_bool: light_cyan
      shape_closure: green_bold
      shape_custom: green
      shape_datetime: purple
      shape_directory: cyan
      shape_external: light_cyan
      shape_externalarg: cyan
      shape_filepath: light_cyan
      shape_flag: cyan
      shape_float: purple
      shape_garbage: { fg: white bg: red attr: b}
      shape_globpattern: cyan_bold
      shape_int: purple
      shape_internalcall: cyan_bold
      shape_list: cyan_bold
      shape_literal: blue
      shape_match_pattern: cyan
      shape_matching_brackets: { attr: u }
      shape_nothing: red
      shape_operator: cyan
      shape_or: purple
      shape_pipe: purple
      shape_range: yellow_bold
      shape_record: cyan_bold
      shape_redirection: purple
      shape_signature: cyan_bold
      shape_string: yellow
      shape_string_interpolation: cyan_bold
      shape_table: blue_bold
      shape_variable: purple
      shape_vardecl: purple
  }

  return $theme
}
