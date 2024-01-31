#!/bin/bash

if [ "$#" -eq 1 ]; then
    if [ -f "$1" ]; then

        sudo docker run --rm -it -v "$(realpath "$1")":/app/$(basename "$1") -w /app ubuntu 

    elif [ -d "$1" ]; then   
        sudo docker run --rm -it -v "$(realpath "$1")":/app -w /app ubuntu
    else
        echo "can mount only file or dir"
    fi
else
    sudo docker run --rm -it btp_build_image
fi

