# BC MODIFICATIONS 2011-07-05 to make scp work again
#
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]] ; then
  # Shell is non-interactive.  Be done now!
  return
fi

for path in ":/c/Program\ Files/AutoHotKey"\
            ":~/Vim/vim74"; do
  if [[ $PATH != *$path* ]]; then
    export PATH=$PATH:$path
  fi
done

export GIT_EDITOR=gvim.exe
export PATH=$PATH:/c/Program\ Files/AutoHotKey
export PATH=$PATH:/c/Program\ Files/Java/jdk1.8.0_45/bin
export PATH=$PATH:/c/Program\ Files/ImageMagick-6.9.1-Q16
export PATH=$PATH:/c/Users/Counter/AppData/Local/Zint

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
      #   0 = agent running, has keys
      #   1 = agent running, no keys
      #   2 = agent not running
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
    (umask 077; ssh-agent >"$env")
    . "$env" >/dev/null
  }

  if ! agent_is_running; then
    agent_load_env
  fi

  # if your keys are not stored in ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.pub, you'll need
  # to paste the proper path after ssh-add
  if ! agent_is_running; then
    agent_start
    ssh-add -t 1h
  elif ! agent_has_keys; then
    ssh-add
  fi

  unset env

# ---------------------------
# here's Doug's config stuff!
# ---------------------------
  alias lt="ls -latr"
  alias lola="git log --graph --decorate --pretty=oneline --abbrev-commit"
  alias gly="git log --pretty=oneline --since='38 hours ago' --abbrev-commit"
  # Specialized history with super grep powers
  alias ghist="history|grep $@"
  alias ep="v ~/.profile"
  alias sp="source ~/.profile"
  alias ld='ls -al -d * | egrep "^d"'

  alias sb="ssh dougc13@150.150.0.15"
  alias ahk="AutoHotKey.exe"
  alias vd='gvim.exe -d --servername diff'
  alias gd='git difftool --noprompt --extcmd="gvim.exe -d --nofork --servername diff"'

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
  gvim.exe --servername v --remote-tab-silent "$@" &
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

function ahk () { AutoHotKey.exe "$@"; }

function vd () {
  gvim.exe -d --servername diff "$@" &
  disown
}

