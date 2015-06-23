#Default .profile junk
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

# ---------------------------
# here's Doug's config stuff!
# ---------------------------
alias f3cp="scp /c/Users/Counter/Documents/expect/f3 dougc13@150.150.0.15:/home/dougc13/autoexpect/f3"
alias lt="ls -latr"
alias sb="ssh dougc13@150.150.0.15"
alias lola="git log --graph --decorate --pretty=oneline --abbrev-commit"
alias gly="git log --pretty=oneline --since='38 hours ago' --abbrev-commit"
# Specialized history with super grep powers
alias ghist="history|grep $@"
alias ep="v ~/.profile"
alias sp="source ~/.profile"
alias ahk="AutoHotKey.exe"
alias ahc="/c/Program\ Files/AutoHotkey/Compiler/Ahk2Exe.exe"

function ahk () { AutoHotKey.exe "$@"; }
function v () { vim "$@" & disown; }
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

function gmp () {
  if ! ssh-add -l; then
    # ssh doesn't have any keys, so add them
    ssh-add -t 1h
  fi

  echo "git checkout $2"
  git checkout $2
  echo "git merge $1"
  git merge $1
  echo "git push"
  git push
  echo "git checkout $3"
  git checkout $3
  echo "git merge $2"
  git merge $2
  echo "git push"
  git push
}

export GIT_EDITOR=/c/Users/Counter/Vim/vim74/gvim.exe

export PATH=$PATH:/c/Program\ Files/AutoHotKey

unset env

