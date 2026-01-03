---
title: 'How to run a user service with systemd'
slug: how-to-run-a-user-service-with-systemd
author: 'Mikael Ståldal'
type: post
date: 2026-01-03T14:00:00+01:00
year: 2026
month: 2026/01
day: 2026/01/03
category:
  - Linux

---

Most Linux systems uses [systemd](https://en.wikipedia.org/wiki/Systemd) as [init](https://en.wikipedia.org/wiki/Init) and service manager nowadays.

You can use systemd to start your services, so that they are automatically restarted if they crash, and automatically started when the system boots.
You can even do this as a regular user, without root access (then the service will run with permissions of your user), and have it automatically 
started when the system boots without you having to login.

1. Create the `~/.config/systemd/user` directory if necessary:
```bash
mkdir -p ~/.config/systemd/user
```

2. Create a [service unit configuration file](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html) 
for your service in that directory `~/.config/systemd/user/myservice.service`:
```
[Unit]
Description=MyService

[Service]
Type=exec
LoadCredential=my-password:%h/myservice.pw
ExecStart=%h/.local/bin/myservice -password-file ${CREDENTIALS_DIRECTORY}/my-password
Restart=on-failure

NoNewPrivileges=true
AppArmorProfile=myservice

[Install]
WantedBy=default.target
```

3. Load the service definition:
```bash
systemctl --user daemon-reload
```

4. Enable the service:
```bash
systemctl --user enable myservice.service
```

5. Start the service
```bash
systemctl --user start myservice.service
```

This will provide the service with credentials from file `~/myservice.pw`, and run the service with [AppArmor](https://en.wikipedia.org/wiki/AppArmor) 
profile `myservice` (which you must create and load first).

Then you can stop the service with `systemctl --user stop myservice.service` and restart it with `systemctl --user restart myservice.service`.

This has been tested on Debian Linux.
