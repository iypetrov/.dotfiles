#!/bin/bash

target="$(echo "master-data-api master-data-fe" | tr ' ' '\n' | fzf)"

if [[ "$target" == "master-data-api" ]]; then
    option="$(echo "feature-1 develop test staging" | tr ' ' '\n' | fzf)"

    if [[ "$option" == "feature-1" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-api/"
        git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 
        git checkout feature-1 -- src/main/resources/application-local.properties > /dev/null 2>&1 
        cd "$o_path"
    elif [[ "$option" == "develop" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-api/"
        git checkout develop -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 
        git checkout develop -- src/main/resources/application-local.properties > /dev/null 2>&1 
        cd "$o_path"
    elif [[ "$option" == "test" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-api/"
        git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 
        git checkout test -- src/main/resources/application-local.properties > /dev/null 2>&1 
        cd "$o_path"
    elif [[ "$option" == "staging" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-api/"
        git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 
        git checkout staging -- src/main/resources/application-local.properties > /dev/null 2>&1 
        cd "$o_path"
    fi
elif [[ "$target" == "master-data-fe" ]]; then
    option="$(echo "local feature-1 develop test staging" | tr ' ' '\n' | fzf)"


    if [[ "$option" == "local" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-fe/"
        git checkout local -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1
        cd "$o_path"
    elif [[ "$option" == "feature-1" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-fe/"
        git checkout feature-1 -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1
        cd "$o_path"
    elif [[ "$option" == "develop" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-fe/"
        git checkout develop -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1
        cd "$o_path"
    elif [[ "$option" == "test" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-fe/"
        git checkout test -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1
        cd "$o_path"
    elif [[ "$option" == "staging" ]]; then
        o_path="$PWD"
        cd "$BPA/master-data-fe/"
        git checkout staging -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1
        cd "$o_path"
    fi
fi
