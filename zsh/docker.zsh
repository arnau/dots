alias dc='docker-compose'
alias di='docker images'
alias dimgs='docker images --format "{{.Repository}}:{{.Tag}}" | fzf'
alias dm='docker-machine'
alias dps='docker ps'
alias drmd='docker ps --filter status=exited -q | xargs docker rm -vf'

drmid() {
  docker images -qf 'dangling=true' | awk '{print $1}' | xargs docker rmi
}
