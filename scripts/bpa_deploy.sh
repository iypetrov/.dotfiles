#!/bin/bash

ERROR_WRONG_TARGET=1
ERROR_UNCOMMITED_CHANGES=2
ERROR_NUMB_ARGS=99

check_valid_target() {
    if [ "$1" = "api" ] || [ "$1" = "fe" ]; then
        return 0
    else
        return 1
    fi
}

ORIGINAL_PATH="$(pwd)"
PATH_API="/mnt/c/Users/ipetrov/stuff/work/projects/besudb/master-data-api"
PATH_FE_SRC="/mnt/c/Users/ipetrov/stuff/work/projects/besudb/master-data-fe"
PATH_FE="/home/ipetrov/master-data-fe"

MTAR_API="./mta_archives/master-data-api_0.0.1.mtar"
MTAR_FE="./mta_archives/master_data_ui_0.0.1.mtar"
MTAR="$MTAR_API"

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
    echo "provide 1 or 2 args (arg 1 is target - api/fe, arg 2 is optional and it is for target branch (by default is the current one))"
    exit $ERROR_NUMB_ARGS
fi

TARGET="$1"
if [ "$TARGET" = "api" ]; then
    cd "$PATH_API"
elif [ "$TARGET" = "fe" ]; then
    cd "$PATH_FE_SRC"
else
    echo "invalid target, please provide 'api' or 'fe'"
    exit $ERROR_WRONG_TARGET
fi

ORIGINAL_GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
GIT_BRANCH="$ORIGINAL_GIT_BRANCH"
if [ "$#" -eq 2 ]; then
    GIT_BRANCH="$2"
fi
echo "target:" "$TARGET;" "branch:" "$GIT_BRANCH"

if ! git diff --quiet; then
    echo "warning: you have uncommitted changes, do you want to proceed and remove them? (y/n)"
    read -r response
    if [[ $response =~ ^[Yy]$ ]]; then
        git stash save --include-untracked
        echo "uncommitted changes stashed"
    else
        echo "operation aborted"
        exit $ERROR_UNCOMMITED_CHANGES
    fi
fi
git checkout "$GIT_BRANCH"

if [ "$TARGET" = "fe" ]; then
    echo "copy FE folder to /home/..."
    rsync -a --delete --exclude=node_modules "$PATH_FE_SRC/" "$PATH_FE/"
    MTAR="$MTAR_FE"
    cd "$PATH_FE"
fi

cf login --sso
mbt build
cf deploy "$MTAR" -f -e mta_dev.mtaext

git checkout "$ORIGINAL_GIT_BRANCH"
cd "$ORIGINAL_PATH"
