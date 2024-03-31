#!/bin/bash

sudo docker build -t btp_build_image "$BPA/btp_build_image"
if [ "$#" -eq 1 ]; then
    if [ -f "$1" ]; then
        sudo docker run --rm -it -v "$(pwd)/$1":/app/$(basename "$1") -w /app btp_build_image
    elif [ -d "$1" ]; then   
        sudo docker run --rm -it -v "$(pwd)/$1":/app -w /app btp_build_image
    else
        echo "can mount only file or dir"
    fi
else
    sudo docker run --rm -it btp_build_image
fi
