#!/usr/bin/env bash

alias dc='docker-compose'
alias di='docker images'
alias dimgs='docker images --format "{{.Repository}}:{{.Tag}}" | fzf'
alias dm='docker-machine'
alias dps='docker ps'
alias drmd='docker ps --filter status=exited -q | xargs docker rm -vf'

drmid() {
  docker images -qf 'dangling=true' | awk '{print $1}' | xargs docker rmi
}

dmenv() {
  eval $(docker-machine env "$1")
  update_ps1
}


###############################################################################
# Docker for Mac tty
#
# login: root
# pwd: nothing
###############################################################################
alias dfm='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
alias dockerlogs='syslog -k Sender Docker'

DOCKER_PATH='/Applications/Docker.app/Contents/Resources/etc'

# shellcheck source=/dev/null
source "$DOCKER_PATH/docker.bash-completion"
# shellcheck source=/dev/null
# source "$DOCKER_PATH/docker-machine.bash-completion"
# shellcheck source=/dev/null
source "$DOCKER_PATH/docker-compose.bash-completion"
