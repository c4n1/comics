#!/bin/bash

UPDATE_FREQUENCY=14400
UPDATE_RANDOM=7200

random_seconds () {
    #$RANDOM returns a random int between 0 and 32767
    #Multiply randomization factor by RANDOM's max, and divide
    #since Bash doesn't deal with floating point
    echo $(((($UPDATE_RANDOM * $RANDOM ) / 32767 ) + $UPDATE_FREQUENCY))
}
periodic_update () {
    while true; do
        sleep=$(random_seconds)
        echo "Sleeping for ${sleep}"
        sleep ${sleep}
        ./page_make.sh
    done
}
#Ensure we really die...
trap 'kill $(jobs -p)' EXIT

#Make sure we're in the correct folder
cd `dirname $0`

#Get initial data
./page_make.sh

#Loop to run the updates
periodic_update &

nginx

kill 1
