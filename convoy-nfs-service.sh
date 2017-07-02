#!/bin/bash -x

# create mount dir
mkdir -p $2 || { echo "unable to create mount dir ($2), exiting" ; exit 1 ; }

# install convoy
curl -L -o /tmp/convoy.tar.gz https://github.com/rancher/convoy/releases/download/v0.5.0/convoy.tar.gz
tar -C /tmp -xvzf /tmp/convoy.tar.gz
mkdir -p /opt/bin
cp /tmp/convoy/convoy /tmp/convoy/convoy-pdata_tools /opt/bin/
mkdir -p /etc/docker/plugins/
echo "unix:///var/run/convoy/convoy.sock" > /etc/docker/plugins/convoy.spec

# mount and run convoy
while :
do
  sleep 2
  if mountpoint $2 ; then
    echo "$2 mounted"
    /opt/bin/convoy daemon --drivers vfs --driver-opts vfs.path=$2
    echo "convoy exited, retrying"
  else
    echo "trying to mount: $1"
    $1 || echo "mounting failed, cmd: $1"
  fi
done
