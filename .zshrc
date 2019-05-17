# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/andrei.liaskovski/.oh-my-zsh"

# Vars
export AWS_PROFILE=main
export account=commons

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git aws kubectl kube-ps1 zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source /usr/local/opt/kube-ps1/share/kube-ps1.sh



# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Custom prompt with aws profile, k8s ns and clustername, git status
NEWLINE=$'\n  ' 
PROMPT="${ret_status} %{$fg[cyan]%}%c%{$reset_color%} aws profile:\$AWS_PROFILE \$(kube_ps1) \$(git_prompt_info) \${NEWLINE}"
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#   SYSTEM ALIASES
# --------------------

# prevent embarassingly running command on whole server
# does not work on osx
# alias chown='chown --preserve-root'
# alias chmod='chmod --preserve-root'
# alias chgrp='chgrp --preserve-root'

# Interactive confirmation
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# set defaults for disk usage and disk free
alias df='df -H'
alias du='du -ch'

# Resume wget by default
alias wget='wget -c'

# Create parent directories on demand ##
alias mkdir='mkdir -pv'

# Colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# get rid of command not found ##
alias cd..='cd ..'

# a quick way to get out of current directory
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# Colorize the ls output
alias ls='ls -ahltG'



# --------------------
#   DOCKER ALIASES
# --------------------

# Get latest container ID
alias dl="docker ps -l -q"
# Get container processes
alias dps="docker ps"
# Get container processes for smaller screens
alias dpsf="docker ps --size --format \"table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Command}}\t{{.Ports}}\" | tail -n +2 | sort"
# Get process included stop container
alias dpa="docker ps --size -a"
# Get images
alias di="docker images"
# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"
# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"
dkill() { docker kill $@; }
# Execute interactive container, e.g., $dex base /bin/bash
alias dex="docker exec -i -t"
# Stop all containers
dstop() { docker stop $(docker ps -a -q); }
# Remove all exited containers
drm() { docker rm -v $(docker ps --filter status=exited -aq); }
# Remove all containers
drmf() { docker rm -v -f $(docker ps -aq); }
# Remove all unused images
dri() { docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc); }
# Remove all images
drif() { docker rmi -f $(docker images -q --no-trunc); }
# Remove all orphaned volumes
drv() { docker volume rm $(docker volume ls --filter "dangling=true" -q); }
# Remove all volumes
drvf() { docker volume rm -f $(docker volume ls -q); }
# Remove all exited containers, unused images and orphaned volumes
alias dclear="drm; drv; dri;"
# Remove all containers, images and volumes with force
alias dclean="drmf; drvf; drif;"
alias dcb="docker-compose build"
alias dcu="docker-compose up"
alias dcs="docker-compose stop"
alias dck="docker-compose kill"
alias dcr="docker-compose rm -f"

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }


# --------------------
#   GIT ALIASES
# --------------------

alias gac='git add -A . && git commit -m' $1
alias gpom='git push origin master'
alias gpod='git push origin develop'
alias gtf='git tag -l | xargs git tag -d && git fetch'
alias gt='git tag'
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gb='git branch'
alias gbd='git branch -d '
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gd='git diff'
alias gda='git diff HEAD'
alias gi='git init'
alias gl='git log'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge --no-ff'
alias gp='git pull'
alias gss='git status -s'
alias gst='git stash'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias grsh='git reset --soft HEAD~${1:-1}'
alias gpps='for ns in *; do echo "\t$ns" && cd $ns && for r in *; do echo "\t\t$r" && cd $r && git pull --recurse-submodules && cd ../; done; cd ../; done'

# Show all alias related git
galias() { alias | grep 'git' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Git log find by commit message
function glf() { git log --all --grep="$1"; }



preexec () {
        case "$(kubectl config current-context)" in
                "staging")
                        export account=staging
                        ;;
                "commons")
                        export account=commons
                        ;;
                "production")
                        export account=production
                        ;;
                "eks-cluster-dev")
                        export account=dev
                        ;;
        esac

}

#
#

#export PATH="/usr/local/opt/mysql-client/bin:$PATH"
#export PATH="/usr/local/bin/minikube"
