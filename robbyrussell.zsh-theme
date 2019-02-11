# to get ➜  kubernetes-core-services-for-eks-cluster  main git:(master)
#AWS Profile:
# - display current AWS_PROFILE name
# - displays yellow on red if profile name contains 'production' or
#   ends in '-prod'
# - displays black on green otherwise
prompt_aws_profile() {
  local aws_profile="$AWS_PROFILE"
  if [[ -n $aws_profile ]]; then
    if [[ $aws_profile == *"prod" || $aws_profile == *"production"* ]]; then
      prompt_segment red yellow  "$aws_profile"
    else
      prompt_segment green black "$aws_profile"
    fi
  fi
}



local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(prompt_aws_profile) $reset_color% $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"


