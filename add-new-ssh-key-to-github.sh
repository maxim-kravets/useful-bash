#!/bin/bash

set -e

GIT_USERNAME=$1

if [ -z $GIT_USERNAME ]; then

	GIT_USERNAME=$(git config user.name)

	if [ -z $GIT_USERNAME ]; then
	    printf "\nYour git configuration doesn't have username.\nPass the username of github account as first argument:\n./add-new-ssh-key-to-github.sh <your_github_username>\n\n"
	    exit 1
	fi
	
fi

ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""

TITLE="Key created by bash script at $(date '+%d-%m-%Y %H:%M:%S')"
KEY=$(cat ~/.ssh/id_rsa.pub)
TEMPLATE='{"title":"%s","key":"%s"}'
JSON_STRING=$(printf "$TEMPLATE" "$TITLE" "$KEY")

curl -d "$JSON_STRING" -H "Content-Type: application/json" -X POST -u $GIT_USERNAME https://api.github.com/user/keys
