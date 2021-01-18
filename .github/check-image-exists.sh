#!/bin/sh

checkImageExists() {
    USER=$1
    REPOSITORY=$2
    IMAGE_TAG=$3

    imageTagPageHttpResponse=`curl --silent -f -lSL https://index.docker.io/v1/repositories/${USER}/${REPOSITORY}/tags/${IMAGE_TAG} > /dev/null ; echo $?`

    if [[ $imageTagPageHttpResponse == 0 ]]; then
        return 1
    else
        return 0
    fi
}
