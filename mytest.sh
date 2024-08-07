#!/bin/bash

if [ -z "$1" ]
then
    echo "Please provide new artifact version argument"
    exit 1
else
    TAG=$1
fi

sed -i -E '0,/<(version)>[^<]+<\/version>/{s/<(version)>[^<]+<\/version>/<version>'$TAG'<\/version>/}' pom.xml

DONE="0"
while [ $DONE -eq 0 ]
do
    echo "Running child module update"
    mvn -N versions:update-child-modules -DgenerateBackupPoms=false | grep -q 'All child modules are up to date.'
    if [ $? -eq 0 ]
    then
        DONE="1"
        echo "All child modules updated"
    fi
done
