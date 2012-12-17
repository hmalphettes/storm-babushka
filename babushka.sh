#!/bin/bash
which babushka
if [ "$?" != "0" ]; then
  if [ -n "$UBUNTU_MIRROR" ]; then
    echo "Setting up the UBUNTU_MIRROR $UBUNTU_MIRROR"
    sed -i -e "s%http://us\.archive\.ubuntu\.com%http://$UBUNTU_MIRROR.archive.ubuntu.com%g" /etc/apt/sources.list
    sed -i -e "s%http://archive\.ubuntu\.com%http://$UBUNTU_MIRROR.archive.ubuntu.com%g" /etc/apt/sources.list
    if [ "$?" != "0" ]; then
      echo "Failed to update $?"
      exit 12
    fi
  fi
  apt-get update
  apt-get install -q -y curl && sh -c "`curl https://babushka.me/up/hard`"
fi
# update babushka install git.
babushka babushka

