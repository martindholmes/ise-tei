#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Uploading files from $DIR to server"

rsync --verbose --progress --stats --recursive --times  --exclude ".svn/" -e ssh "$DIR/../dist/" hcmc@nfs.hcmc.uvic.ca:/home1t/hcmc/www/workshops/ise/

echo "Done"
