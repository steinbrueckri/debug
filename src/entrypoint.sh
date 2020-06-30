#!/bin/bash

## Run all init scripts #######################################################

if [[ -d "/entrypoint.d" ]]
then
  /bin/run-parts --exit-on-error --verbose --regex '\.(sh|rb)$' "$DIR"
fi

## Start Processes ############################################################

/usr/bin/supervisord -n
