-- Colours outside of the CSS named palette.
local palette = {
  dimwhite = "hsl(34, 100%, 93%)",
  dimblack = "hsl(0, 0%, 15%)",
  lightgold = "hsl(40, 100%, 80%)",
  lightgreen = "hsl(120, 20%, 75%)",
}

-- Map to ANSI names to clarify what is what.
local ansi = {
  black = "black",
  blue = "lightsteelblue",
  cyan = "lightblue",
  green = "darkseagreen",
  purple = "pink",
  red = "lightsalmon",
  white = "lightgray",
  yellow = "khaki",

  bold_black = "dimgray",
  bold_blue = "skyblue",
  bold_cyan = "paleturquoise",
  bold_green = palette.lightgreen,
  bold_purple = "hotpink",
  bold_red = "salmon",
  bold_white = "white",
  bold_yellow = palette.lightgold,
}

local theme = {
  foreground = palette.dimwhite,
  background = palette.dimblack,
  cursor_bg = "gold",
  cursor_fg = "black",
  cursor_border = "gold",

  ansi = {
    ansi.black,
    ansi.red,
    ansi.green,
    ansi.yellow,
    ansi.blue,
    ansi.purple,
    ansi.cyan,
    ansi.white,
  },
  brights = {
    ansi.bold_black,
    ansi.bold_red,
    ansi.bold_green,
    ansi.bold_yellow,
    ansi.bold_blue,
    ansi.bold_purple,
    ansi.bold_cyan,
    ansi.bold_white,
  },
}

return theme