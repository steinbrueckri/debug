#!/bin/bash

if [ -z "$SSHUSERS" ]
then
    echo "Environment variable SSHUSERS is not defined, use default"
    SSHUSERS=(steinbrueckri)
else
    echo "Environment variable SSHUSERS is set to '$SSHUSERS'"
fi

for SSHUSER in $SSHUSERS
do
    echo "Donwload publickey from GitHub user https://github.com/$SSHUSER"
    curl https://github.com/$(SSHUSER).keys >> /root/.ssh/authorized_keys
done
