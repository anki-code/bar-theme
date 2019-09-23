#
# Origin: https://github.com/anki-code/zsh-bar-theme
#

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[250]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

_PATH="%{$fg_bold[white]%}%~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _LIBERTY="%{$FG[255]%}#"
else
  _LIBERTY="%{$FG[250]%}$"
fi

get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  local SPACES="%{$BG[234]%}"
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))

  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

export ZSH_FIRST=1

bar () {
  # git
  git=$(git_prompt_info)
  _git_=`[[ "$git" == ''  ]] && V="" || V=" %{$FG[254]%}%{$BG[236]%}$git%{$BG[236]%} %{$reset_color%}"; echo $V`

  # conda
  _condaenv_=`[[ $CONDA_DEFAULT_ENV == 'base' || $CONDA_DEFAULT_ENV == '' ]] && V="" || V=" %{$FG[254]%}%{$BG[236]%} $CONDA_DEFAULT_ENV %{$reset_color%}"; echo $V`

  # Run `spectrum_ls` to search colors
  [[ $ZSH_THEME_BAR_HOSTCOLOR == '' ]] && bhc=244 || bhc=$ZSH_THEME_BAR_HOSTCOLOR

  # bar
  _1LEFT="%{$BG[234]%}%{$FG[$bhc]%}%n %m%{$reset_color%}%{$BG[234]%} %{$FG[253]%}%~%{$reset_color%}"
  _1RIGHT="%{$BG[234]%}%{$FG[250]%}$_git_%{$BG[234]%}%{$FG[250]%}$_condaenv_%{$BG[234]%}%{$FG[250]%} %{$FG[244]%}`date --rfc-3339=sec`%{$reset_color%}"
  _1SPACES=`get_space $_1LEFT $_1RIGHT`
  print
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

zle_highlight=( default:fg=green,bold )
PROMPT='$(bar)
$_LIBERTY '
