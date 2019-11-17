## Bar theme

Features:

* It looks not like Christmas tree. Most of themes ([omz examples](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes)) look like Christmas garland and frustrate attention 🎄 💈. But terminal is most for write commands and get output, not for color juggling 🖥 

* It has three attention aspects by priority: first - command and path, second - output, third - pills/sections 👓 

* It has a bar along all space and it is a great separator ⬛️ 

* The command beginning has fixed position and command has color with intensity. It's great for reading and typing 💚 

* The pills/sections placed to right but not in RPROMPT and it allows you to secure copy the command and output without environmental disclosure 🔒 

* The pills/sections can have additional background or color accent if you need 💊 

## Appearance

![zsh bar theme](zsh-bar-theme-example.png)

Screeshot from [Hyper](https://hyper.is) with [Fira Code](https://github.com/tonsky/FiraCode) or something like this.

## [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/)
```
git clone https://github.com/anki-code/zsh-bar-theme ~/.oh-my-zsh/custom/themes/zsh-bar-theme
ln -s ~/.oh-my-zsh/custom/themes/zsh-bar-theme/bar.zsh-theme ~/.oh-my-zsh/custom/themes/bar.zsh-theme
sed -i  's/^ZSH_THEME=/ZSH_THEME="bar"\n#ZSH_THEME=/g' ~/.zshrc
zsh
```

## [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
1. `.zshrc` settings:
```
POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user host dir newline prompt_char)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs command_execution_time background_jobs virtualenv anaconda pyenv nodenv nvm nodeenv rbenv rvm kubecontext terraform nordvpn ranger time newline)
POWERLEVEL9K_TIME_FORMAT='%D{%y-%m-%d %H:%M:%S%z}'
POWERLEVEL9K_BACKGROUND=234
POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=234
POWERLEVEL9K_USER_FOREGROUND=244
POWERLEVEL9K_HOST_FOREGROUND=244
POWERLEVEL9K_ANACONDA_FOREGROUND=244
POWERLEVEL9K_VCS_FOREGROUND=244
POWERLEVEL9K_TIME_FOREGROUND=244
zle_highlight=( default:fg=green,bold )
```
2. Also you can try the proof of concept config [p10k-bar.zsh](https://gist.github.com/romkatv/7f48d0deae7a3449f34a4870feaba0f5). It work but not recommended because it disable many `p10k` features.

## [xonsh](https://github.com/xonsh/xonsh) PoC
```
import os, socket, getpass, time

def bar():
  BARBG='{BACKGROUND_#181818}'
  BARFG='{#AAA}'
  PILLBG='{BACKGROUND_#333}'
  PILLFG='{#CCC}'
  LIGHTGREY='{BOLD_#DDD}'
  NOC='{NO_COLOR}'

  ts = os.get_terminal_size()
  cols = ts.columns
  pwd = os.getcwd()
  current_time = time.localtime()
  date = time.strftime('%y-%m-%d %H:%M:%S%z', current_time)
  hst = socket.gethostname()
  usr = getpass.getuser()
  
  pills = {
	'conda_env': str($CONDA_DEFAULT_ENV if 'CONDA_DEFAULT_ENV' in ${...} and $CONDA_DEFAULT_ENV != 'base' else '')
  }
  
  pillst = ""
  pillsc = ""
  pills_cnt = 0
  for p,t in pills.items():
    if t:
		pills_cnt+=1
		pillst += '%s ' % t
		pillsc += '{PILLBG}{PILLFG} %s {NOC}{BARBG}{BARFG} ' % t
  
  lp="{hst} {usr} {pwd}".format(pwd=pwd, hst=hst, usr=usr)
  rp="{pillst} {date}".format(date=date, pillst=pillst)

  lpc="{hst} {usr} {LIGHTGREY}{pwd}{NOC}".format(pwd=pwd, hst=hst, usr=usr, LIGHTGREY=LIGHTGREY, NOC=NOC)
  rpc=("%s{BARBG}{BARFG} {date}" % pillsc).format(date=date, BARBG=BARBG, BARFG=BARFG, PILLBG=PILLBG, PILLFG=PILLFG, NOC=NOC)

  wlen = int(cols) - len(lp) - len(rp) - 3*pills_cnt + (pills_cnt if pills_cnt > 0 else 0)
  w = ' '*wlen
  bar = '{lpc}{BARBG}{BARFG}{w}{rpc}'.format(lpc=lpc, w=w, rpc=rpc, BARBG=BARBG, BARFG=BARFG)
  return '%s%s%s{NO_COLOR}' % (BARBG, BARFG, bar)


$PROMPT_FIELDS['bar'] = bar
$PROMPT="\n{bar}\n{WHITE}{prompt_end}{NO_COLOR} "

$XONSH_COLOR_STYLE="paraiso-dark"

# $COMPLETIONS_CONFIRM=True
```

## bash PoC
```
trap 'echo -ne "\e[0m"' DEBUG
function prompt_command {
        local l="`hostname` `whoami` `pwd`"
        local r="`date --rfc-3339=sec`"
        local ls=${#l}
        local rs=${#r}
        let ss=$COLUMNS-$ls-$rs-2
        local sp="`printf %${ss}s | tr ' ' ' '`"
        echo -e "\n\e[48;5;234m$l $sp $r\e[0m"
}

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} prompt_command"
export PS1='\$ \[\033[01;32m\]' 
```
