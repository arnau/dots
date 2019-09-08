#!/usr/bin/env bash

reset=$(tput sgr0)
yellow=$(tput setaf 11)
blue=$(tput setaf 12)
grey=$(tput setaf 8)

white=$(tput setaf 15)

git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

update_ps1() {
  export PS1="\[$grey\]\! \[$blue\]\W \[$yellow\]\$(git_branch)\[$grey\]·\[$yellow\]$DOCKER_MACHINE_NAME \[$white\]» \[$reset\]"
}

update_ps1
