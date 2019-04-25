#!/bin/bash

set -e

git --version > /dev/null 2>&1
GIT_INSTALLED=$?

if [[ "$GIT_INSTALLED" -ne 0 ]]; then
    printf "\nGit is not installed. You need to install it first.\n\n"

    exit 1
fi

git_username=$1

if [[ -z "$git_username" ]]; then

	git_username=$(git config user.name)
	
fi

if [[ -z "$git_username" ]]; then
    printf "\nYour git configuration doesn't have username.\n"
    printf "Pass the username of github account as first argument:\n"
    printf "%s <your-github-username>\n\n" "$0"

    exit 1
fi

ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""

TITLE="Key created by bash script at $(date '+%d-%m-%Y %H:%M:%S')"
KEY=$(cat ~/.ssh/id_rsa.pub)
BODY=$(printf '{"title":"%s","key":"%s"}' "$TITLE" "$KEY")

curl -d "$BODY" -H "Content-Type: application/json" -X POST -u "$git_username" https://api.github.com/user/keys
