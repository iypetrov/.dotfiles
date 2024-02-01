#!/bin/bash

opath=$(pwd)

trg=$(echo -e "api\nfe" | fzf)
if [[ "$trg" == "api" ]]; then
	cd $BESUDB/master-data-api
else
	cd $BESUDB/master-data-fe
fi

is_current_gbranch=$(echo -e "current branch\nother branch" | fzf)
gbranch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
ogbransh="$gbranch"
if [[ "$is_current_gbranch" == "other branch" ]]; then
	gbranch=$(git branch -r | sed -e 's/^[ \t]*//' | fzf)
fi

echo "$trg"
echo "$gbranch"

git stash
git checkout "$gbranch"

# deploy

git checkout "$ogbranch"
git stash apply "$(git stash list | head -n 1 | cut -d: -f1)"
cd "$opath"
