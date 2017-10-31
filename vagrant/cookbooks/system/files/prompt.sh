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

function git_status() {
    local modified=0;
    local added=0;
    local deleted=0;
    local renamed=0;
    local copied=0;
    local untracked=0;
    local ignored=0;

    local output=$(git status -s 2>/dev/null)

    OIFS="${IFS}"
    IFS=$'\n'
    for line in ${output}; do
        if   [[ $line == M* ]]; then
            modified=$((modified+1));
        elif [[ $line == A* ]]; then
            added=$((added+1));
        elif [[ $line == D* ]]; then
            deleted=$((deleted+1));
        elif [[ $line == R* ]]; then
            renamed=$((renamed+1));
        elif [[ $line == C* ]]; then
            copied=$((copied+1));
        elif [[ $line == ?* ]]; then
            untracked=$((untracked+1))
        elif [[ $line == !* ]]; then
            ignored=$((ignored+1));
        fi
    done
    IFS="${OIFS}"

    s=''
    if [ $modified != "0" ]; then
        s+="$yellow*${modified} ";
    fi
    if [ $added != "0" ]; then
        s+="$yellow+${added} ";
    fi
    if [ $deleted != "0" ]; then
        s+="$red-${deleted} ";
    fi
    if [ $renamed != "0" ]; then
        s+="$yellow*${renamed} ";
    fi
    if [ $copied != "0" ]; then
        s+="$yellow*${copied} ";
    fi
    if [ $untracked != "0" ]; then
        s+="$green?${untracked} ";
    fi
    if [ $ignored != "0" ]; then
        s+="$white\${ignored} ";
    fi

    echo $s
}

function git_branch_status() {
     # check if we're in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch=$(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')
    local ahead=$(git rev-list --left-right $branch...origin/$branch 2>/dev/null | grep -c '^<' | tr -d ' ')
    local behind=$(git rev-list --left-right $branch...origin/$branch 2>/dev/null | grep -c '^>' | tr -d ' ')
    local out=""
    if [[ "$ahead" -gt 0 ]]; then out+="↑$ahead"; fi
    if [[ "$behind" -gt 0 ]]; then out+="↓$behind"; fi
    if [[ "$out" != "" ]]; then echo $blue $out; fi
}

function git_info() {
    # check if we're in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return

    # quickest check for what branch we're on
    local branch=$(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')
    local tag=$(git describe 2>/dev/null)

    if [ "$branch" = "" ] && [ "$tag" != "" ]; then
        branch=$branch#$tag
    fi


    # Count number of changes
    local s='';
    local changes="$(git status -s | wc -l | tr -d ' ')"
    if [ "$changes" == 0 ]; then
        s=$green$branch
    else
        s=$orange$branch' '$(git_status)
    fi

    # Check for stashes
    local stashes=$(git stash list | wc -l | tr -d ' ')
    if [ $stashes != "0" ]; then
        s+="$orange ⚑$stashes";
    fi

    # echo $black'['$s$black']';
    echo $s$(git_branch_status);
}


# Color user details red when user is root
if [ $EUID == "0" ]; then
    usercolor=$red;
else
    usercolor=$green;
fi

# Nicely formatted terminal prompt
export PS1='\n\[$orange\]\h:\[$yellow\]\w  $(git_info) \n\[$usercolor\]\u:\[$reset\] '