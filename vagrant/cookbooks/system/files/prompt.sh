#########################################################################
# This file is managed by puppet, any manual changes might be overwritten
#########################################################################

#!/bin/bash

if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

if tput setaf 1 &> /dev/null; then
    bold=$(tput bold);
    reset=$(tput sgr0);
    black=$(tput setaf 0);
    blue=$(tput setaf 31);
    cyan=$(tput setaf 115);
    green=$(tput setaf 113);
    orange=$(tput setaf 172);
    pink=$(tput setaf 161);
    red=$(tput setaf 160);
    violet=$(tput setaf 103);
    yellow=$(tput setaf 214);
    white=$(tput setaf 15);
    grey=$(tput setaf 239);
else
    bold='';
    reset="\e[0m";
    black="\e[1;30m";
    blue="\e[1;34m";
    cyan="\e[1;36m";
    green="\e[1;32m";
    orange="\e[1;33m";
    purple="\e[1;35m";
    red="\e[1;31m";
    violet="\e[1;35m";
    white="\e[1;37m";
    yellow="\e[1;33m";
    grey="\e[1;33m";
fi;

# Return git status in prompt form
function _git_status() {

    # Unstaged counts
    local M2=0;
  local A2=0;
  local D2=0;
  local R2=0;
  local C2=0;
  local U2=0;
    local I2=0;

    # Staged counts
    local M1=0;
  local A1=0;
  local D1=0;
  local R1=0;
  local C1=0;
  local U1=0;

    # Output
    local unstaged='';
  local staged='';
    local result='';

    # Don't split on whitespace characters
    ORIGINAL_IFS="${IFS}"; IFS=$'\n';

    # Loop git status
    for line in $(git status -s --porcelain 2>/dev/null); do
    # Count staged items
    case ${line:0:1} in
      'M') ((M1+=1));;
      'D') ((D1+=1));;
      'A') ((A1+=1));;
      'R') ((R1+=1));;
      'C') ((C1+=1));;
      'U') ((U1+=1));;
    esac;

        # Count unstaged items
        case ${line:1:1} in
            'M') ((M2+=1));;
            'D') ((D2+=1));;
            'A') ((A2+=1));;
            'R') ((R2+=1));;
            'C') ((C2+=1));;
            '?') ((U2+=1));;
            '!') ((I2+=1));;
        esac;
    done;

    # Reset split on whitespace
    IFS="${ORIGINAL_IFS}"

    for state in {M2,A2,D2,R2,C2,U2,I2,M1,A1,D1,R1,C1}; do
        if [ "${!state}" != "0" ]; then
            case "$state" in
        # Staged
        M1) staged+=" ${yellow}*${!state}$reset";;
        A1) staged+=" ${green}+${!state}$reset";;
        D1) staged+=" ${red}-${!state}$reset";;
        R1) staged+=" ${blue}~${!state}$reset";;
        C1) staged+=" ${blue}C${!state}$reset";;
        U1) staged+=" ${blue}C${!state}$reset";;

        # Unstaged items
                M2) unstaged+=" ${yellow}*${!state}$reset";;
                A2) unstaged+=" ${green}+${!state}$reset";;
                D2) unstaged+=" ${red}-${!state}$reset";;
                R2) unstaged+=" ${blue}~${!state}$reset";;
                C2) unstaged+=" ${blue}C${!state}$reset";;
                U2) unstaged+=" ${blue}?${!state}$reset";;
                I2) unstaged+=" ${blue}?${!state}$reset";;
            esac;
        fi
    done

    # Trim whitespace
    unstaged=$(echo $unstaged | sed -e "s/^ *//");
    staged=$(echo $staged | sed -e "s/^ *//");

  # Compile result
  if [[ $unstaged != "" ]]; then
    result+=$reset"[$unstaged]";
  fi
  if [[ $staged != "" ]]; then
    result=$green[$staged$green]$result;
  fi

    # Return output
    echo $result;
}

# Return branch being ahead or behind the remote
function _git_position() {
    local branch=$(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||');
    local ahead=$(git rev-list --left-right $branch...origin/$branch 2>/dev/null | grep -c '^<' | tr -d ' ');
    local behind=$(git rev-list --left-right $branch...origin/$branch 2>/dev/null | grep -c '^>' | tr -d ' ');
    local pos="";
    if [[ "$ahead" -gt 0 ]]; then pos+="↑$ahead"; fi
    if [[ "$behind" -gt 0 ]]; then pos+="↓$behind"; fi
    if [[ "$pos" != "" ]]; then echo $blue$pos; fi
}

# Compile git prompt using branch, status and position
function git_prompt() {
    # check if we're in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return

    # Add tag info if available
    local branch=$(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')
    local tag=$(git describe 2>/dev/null)
    if [ "$tag" != "" ]; then
      branch="$branch$orange#$tag"
    fi

    # Color based on number of changes
    local status=$(_git_status);
    if [ "$status" == "" ]; then
      result=$green"$branch"
    else
      result="$yellow$branch $status";
    fi

    # Check for stashes
    local stashes=$(git stash list | wc -l | tr -d ' ')
    if [ $stashes != "0" ]; then
      result+="$orange ⚑$stashes";
    fi

    echo $result $(_git_position)$reset;
}

# Color user details red when user is root
if [ $EUID == "0" ]; then
    usercolor=$red;
else
    usercolor=$yellow;
fi

# Nicely formatted terminal prompt
export PS1='\n\e[1m\[$usercolor\]\u\[$white\]@\[$cyan\]\h  \e[21m\[$grey\]$PWD  $(git_prompt) \n\[$usercolor\]> \[$reset\]'
