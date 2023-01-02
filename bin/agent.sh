#!/bin/echo This file must be run in the same process with "." (source)
#
# Author: @mbonastre https://github.com/mbonastre
#
# Updated: 2023-01-01
#
# This script allows easy use of "ssh-agent" from any terminal.
# Works in Linux and MacOS.
#
# Possible improvements:
#  - Currently, the password is requested in the terminal.
#    With proper configuration, an X11 window could request it.
#    Look at "SSH_ASKPASS" variable.
#

# To use this script, add these lines at the end of ".bashrc"
# (or equivalent file; I have only tested it in bash):
#
#  if [ -x ${HOME}/bin/agent.sh ] ; then
#    . ${HOME}/bin/agent.sh
#  fi
#

# Set TTL (maximum time to ask for password again)
#   130000  = 36h (asks at the begining of work day, every other day)
#   1300000 = 15 dies
#   2600000 = 30 dies (I use it on holidays if I leave scheduled processes)
TTL=130000

load_keys() {
  ssh-add -l || ssh-add

  # "ssh-add -l" Lists currently load keys
  #   Fails if no identity is loaded
  #
  # "ssh-add" loads defalt identity (id_rsa)
  #   Is executed only if "ssh-add -l" fails
  #   Will request password if key is protected
  #  
  # You can modify this part if you want more keys or non-default ones:
  #  - One non-default key: just add the path-name to the second "ssh-add"
  #  - More than one key: replicate lines, checking for the specific key presence
  #
}

if ! [ -d "${HOME}/.ssh" ] ; then
  # If no .ssh dir, we do nothing
  return
fi

# STEP 1: Verify if environment variables are already set
#   (some other software may have already been configured)
#   (GNOME keyring-daemon or similar)

if [ -n "${SSH_AUTH_SOCK}" ] && [ -n "${SSH_AGENT_PID}" ]; then
  if ! [ -S "${SSH_AUTH_SOCK}" ] ; then
    # No socket means invalid variables
    unset SSH_AUTH_SOCK
    unset SSH_AGENT_PID
  else
    # We save environment to our file
    cat > ${HOME}/.ssh/ssh_auth_env <<EOF
SSH_AUTH_SOCK=${SSH_AUTH_SOCK}; export SSH_AUTH_SOCK;
SSH_AGENT_PID=${SSH_AGENT_PID}; export SSH_AGENT_PID;
echo Agent pid ${SSH_AGENT_PID};
EOF
  fi
fi


# STEP 2: load and check saved environment
#  - Verify if environment file exists and load variables
#  - If socket invalid, remove file (it is stale)
#
if [ -f ${HOME}/.ssh/ssh_auth_env ]; then
   .  ${HOME}/.ssh/ssh_auth_env
   [ -S "${SSH_AUTH_SOCK}" ] || rm ${HOME}/.ssh/ssh_auth_env
fi

# STEP 3: launch ssh-agent if necessary
#  - If no environment file, launch ssh-agent
#  - Store and load variables
#  - Set TTL (maximum time to ask for password again)
#
if [ ! -f ${HOME}/.ssh/ssh_auth_env ]; then
  ssh-agent -t ${TTL} > ${HOME}/.ssh/ssh_auth_env
  .  ${HOME}/.ssh/ssh_auth_env
fi


# STEP 4: Load identity, if necessary
load_keys

unset -f load_keys
