# convoy-nfs-rancher

Use a docker-provided nfs service as container storage via convoy

# Usage

Given a mount command (e.g. `mount -t nfs -o rw 10.42.202.184:/gv1 /opt/convoy`)
and a mount point (e.g. `/opt/convoy`), add the following to `coreos.units` in
`/var/lib/coreos-install/user_data`:

```
  - name: convoy-nfs.service
    command: start
    content: |
      [Unit]
      Description=Convoy NFS Daemon
      [Service]
      User=root
      WorkingDirectory=/tmp
      ExecStartPre=/usr/bin/mkdir -p /opt/bin
      ExecStartPre=/usr/bin/curl -L -o /opt/bin/convoy-nfs-service.sh https://github.com/Uber5/convoy-nfs-rancher/releases/download/v0.1.0/convoy-nfs-service.sh
      ExecStartPre=/usr/bin/chmod 755 /opt/bin/convoy-nfs-service.sh
      ExecStart=/opt/bin/convoy-nfs-service.sh "mount -t nfs -o rw 10.42.202.184:/gv1 /opt/convoy" /opt/convoy
      [Install]
      WantedBy=multi-user.target
```


