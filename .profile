#############################
#Various ENVs
#############################
export PATH=/opt/local/bin:/opt/local/sbin:$PATH:/Applications/MATLAB_R2012a.app/bin/
DYLD_FALLBACK_LIBRARY_PATH=${macports_prefix}/lib 

# added by Anaconda 1.5.1 installer
export PATH="/Users/liuhao/anaconda/bin:$PATH"
export PATH=/Users/liuhao/anaconda/bin:$PATH

#Cuda path
export PATH=/Developer/NVIDIA/CUDA-5.0/bin/:$PATH
export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-5.0/lib:$DYLD_LIBRARY_PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

#Some system alias
alias ll='ls -l'
alias rm='rm -i'
alias grep='grep --color=auto'

#ls output color
export CLICOLOR=1

# bash-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
        . /opt/local/etc/profile.d/bash_completion.sh
fi

# Setup Amazon EC2 Command-Line Tools
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=`ls $EC2_HOME/pk-*.pem`
export EC2_CERT=`ls $EC2_HOME/cert-*.pem`
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

#############################
#SSH setup
#############################
#Cognical login
alias sshnc='ssh -i ~/.ec2/ec2-keypair.pem ubuntu@ec2-23-21-157-18.compute-1.amazonaws.com'
alias sshnc2='ssh -i ~/.ec2/ec2-keypair.pem ubuntu@ec2-23-23-116-178.compute-1.amazonaws.com'

#hpc login
alias sshhpc='ssh hl1283@hpc.nyu.edu'

#############################
#The extent files
#############################
if [ -f ~/.dances ]; then
    source ~/.dances
fi

#############################
# colorized prompt
#############################
if [ -x /usr/bin/tput ] && tput setaf 1 >& /dev/null; then
  # we have color support
  color_prompt=yes
  export "HI"
else
  color_prompt=
fi

if [ "$color_prompt" = yes ]; then
  BLD=$(tput bold)
  RST=$(tput sgr0)
  RED=$(tput setaf 1)
  GRN=$(tput setaf 2)
  YLW=$(tput setaf 3)
  BLU=$(tput setaf 4)
  MAG=$(tput setaf 5)
  CYN=$(tput setaf 6)
  WHT=$(tput setaf 7)
else
  BLD=""
  RST=""
  RED=""
  GRN=""
  YLW=""
  BLU=""
  MAG=""
  CYN=""
  WHT=""
fi

function seperator {
  if [ $? -eq 0 ]; then
    COLOR=$BLD$GRN
  else
    COLOR=$BLD$RED
  fi

  if [[ $timer_result -gt 60 ]]; then
    echo "${RED}>>> elapsed time ${timer_result}s"
  elif [[ $timer_result -gt 5 ]]; then
    echo "${MAG}>>> elapsed time ${timer_result}s"
  fi

  echo -n $COLOR
  
  if [[ $NOBAR -eq 0 ]]; then
  case $OSTYPE in
    linux-gnu*)
      printf '_%.0s' `seq 1 $COLUMNS`
      ;;
    darwin*)
      jot -s "" -b "_" $COLUMNS -n
      ;;
  esac
  fi
  echo -n $RST
}
function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_result=$(($SECONDS - $timer))
  unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

#The git support to check the status of repo
function git_char {
    #The branch
    BRC=`git branch 2>/dev/null | grep ^* | sed -e "s/*//"`
    #Whether modified 
    MODI=`git status 2>/dev/null | grep "Changes not staged for commit:"| wc -l`
    #Whether commit the staged files
    CMT=`git status 2>/dev/null | grep "Changes to be committed:"| wc -l`
    UNTF=`git status 2>/dev/null | grep "Untracked files:"| wc -l`
    
    if [ "$BRC" == "" ]; then
        echo -n "${MAG} No ✈ ❡ї✞ ${GRN}☝ "
        return
    fi
    echo -n "${MAG} ✈ ❡ї✞ ${RST}☺ℵ${RED}$BRC ${GRN}"
    if [ "$MODI" -ne "0" ]; then 
        echo -n "✍ "
    else
        echo -n "✌"
    fi
    if [ "$CMT" -ne "0" ]; then
        echo -n "✍ "
    else
        echo -n "✌"
    fi
    if [ "$UNTF" -ne "0" ]; then
        echo -n " ${RED}+"
    fi
}

#Another git: ᘐ ᓮ ☂ 
export PS1='$(seperator)${BLD}${GRN}[${RST}${CYN}\u${RST}@${CYN}\h${RST}${BLD}${GRN}] ${RST}☤ℵ ${BLU}\w $(git_char)\n ${BLD}${GRN} ☞ ${RST} '
#export PS1='$(seperator)\n${debian_chroot:+($debian_chroot)}${GRN}${BLD}[${RST}\[\033[00;36m\]\u\[\033[00;31m\]@\[\033[00;36m\]\h\[\033[00;33m\]${GRN}${BLD}]${RST}:\[\033[00;31m\]\w\[\033[00m\]\n${BLD}${GRN}➳  ${RST}'$

#toggle the PS1 w/wo bar
NOBAR=1
function bar_hao {
    if [[ $NOBAR -eq 0 ]]; then
        NOBAR=1
    else
        NOBAR=0
    fi
}
