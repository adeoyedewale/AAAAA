#!/bin/bash

if [ -z "$1" ]
then
    echo "Please provide new artifact version argument"
    exit 1
else
    TAG=$1
fi

# Replace content of first version element in parent project
sed -i -E '0,/<(version)>[^<]+<\/version>/{s/<(version)>[^<]+<\/version>/<version>'$TAG'<\/version>/}' pom.xml

# Replace nested version inside parent element in child modules
for child_dir in $(find . -name "pom.xml" -not -path "./pom.xml" -exec dirname {} \;)
do
    echo "Updating parent version in $child_dir/pom.xml"
    sed -i -E '/<parent>/,/<\/parent>/s/<(version)>[^<]+<\/version>/<version>'$TAG'<\/version>/' "$child_dir/pom.xml"
done

# Update modules Parent version
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
