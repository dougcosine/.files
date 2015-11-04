# BC MODIFICATIONS 2011-07-05 to make scp work again
#
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'MINGW32'* ]]; then
  platform='mingw32'
fi

if [[ $platform == 'mingw32' ]]; then
  for path in ":/c/Program\ Files/AutoHotKey"\
              ":/c/Program\ Files/Java/jdk1.8.0_45/bin"\
              ":/c/MinGW/bin"\
              ":/c/MinGW/msys/1.0/bin"\
              ":~/XAMPP/php/"\
              ":~/Vim/vim74"; do
    if [[ "$PATH" != *"$path"* ]]; then
      export PATH=$PATH:$path
    fi
  done

  export vimExecutable=~/Vim/vim74/gvim.exe
else
  export vimExecutable=vim
fi

export GIT_EDITOR=$vimExecutable

# ssh key initialization
  # Note: ~/.ssh/environment should not be used, as it
  #       already has a different purpose in SSH.

  env=~/.ssh/agent.env

  # Note: Don't bother checking SSH_AGENT_PID. It's not used
  #       by SSH itself, and it might even be incorrect
  #       (for example, when using agent-forwarding over SSH).

  agent_is_running() {
    if [ "$SSH_AUTH_SOCK" ]; then
      # ssh-add returns:
      #   0 = agent running, has keys, first operand of 'or' succeeds,
      #       function returns true
      #   1 = agent running, no keys, second operand of 'or' succeeds,
      #       function returns true
      #   2 = agent not running, 'or' fails, functions returns false
      ssh-add -l >/dev/null 2>&1 || [ $? -eq 1 ]
    else
      false
    fi
  }

  agent_has_keys() {
    ssh-add -l >/dev/null 2>&1
  }

  agent_load_env() {
    . "$env" >/dev/null
  }

  agent_start() {
    (umask 077; ssh-agent > "$env")
    . "$env" >/dev/null
  }

  # if your keys are not stored in ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.pub,
  # you'll need to paste the proper path after ssh-add
  if ! agent_is_running; then
    agent_start
    ssh-add -t 1h
  elif ! agent_has_keys; then
    if [ "$dontAddSSHKeys" ]; then
      ssh-add -t 1h
    fi
  fi

  unset env

# ---------------------------
# here's Doug's config stuff!
# ---------------------------
  alias lt="ls -latr"
  alias lola="git log --graph --decorate --pretty=oneline --abbrev-commit"
  alias gly="git log --pretty=oneline --since='38 hours ago' --abbrev-commit"
  # Specialized history with super grep powers
  alias gh="history|grep $@"
  alias ep="v ~/.profile"
  alias sp="source ~/.profile"
  alias ld='ls -al -d * | egrep "^d"'

  alias sb="ssh dougc13@150.150.0.15"
  alias ahk="AutoHotKey.exe"
  alias vd='$vimExecutable -d --servername diff'
  alias gd='git difftool --noprompt --extcmd="$vimExecutable -d --nofork --servername diff"'
  # add ssh keys
  alias sa="addSSHKeys"

function addSSHKeys() {
  if ! ps aux|grep [s]sh-agent; then
    eval `ssh-agent`
  fi
  ssh-add -t 1h
}

function rsync() {
  cmd "/C rsync $@"
}

function getConfirmation() {
  message=$1
  read -p "$message" -n 1 -r
  echo
  if [[ "$REPLY" == "y" ]]
  then
    return 0
  else
    return 1
  fi
}

function v () {
  $vimExecutable --servername v --remote-tab-silent "$@" &
  disown
}

# commit with an optional message, then push to remote
function gcp () {
  if ! ssh-add -l; then
    # ssh doesn't have any keys, so add them
    ssh-add -t 1h
  fi

  if [ $# -eq 0 ]; then
    # a commit message wasn't supplied, don't include the -m switch
    echo "git commit -a; git push;"
    git commit -a
  else
    # there is a message, include it and the -m switch
    echo "git commit -am \"$@\"; git push;"
    git commit -am "$@"
  fi
  git push
}

# git merge alias
function gm () {
  git merge $1
}

function gmc() {
  branch=$1
  command=$2
  if [ `pwd` -ef ~/expect ] ||\
    getConfirmation "Not in ~/expect. continue? "; then
    gm $branch
    $command
  fi
}

function ahk () {
  AutoHotKey.exe "$@"
}

function vd () {
  $vimExecutable -d --servername diff "$@" &
  disown
}

