### cleanup syslog

`sudo journalctl --vacuum-size=50M / --vacuum-time=1d`

`truncate -s 0 syslog`

### base64 encrypt / decrypt:

`echo -n "geonode" | base64`

`echo -n "Z2Vvbm9kAF==" | base64 -d`

### find text across subdirectories

`grep -r "string" /path`

### visudo / sudoers

Members of the admin group may gain root privileges
`%admin ALL=(ALL) ALL`

Allow members of group sudo to execute any command
`%sudo ALL=(ALL:ALL) /usr/bin/pip3, /usr/bin/git, !/bin/su`

See sudoers(5) for more information on "#include" directives:
`#includedir /etc/sudoers.d`
`%jupyterhub ALL= NOEXEC: /usr/bin/sudo, /usr/bin/pip3`

# BASH

To get the assigned value, or default if it's missing:

`FOO="${VARIABLE:-default}"`  # If variable was unset or null, use default.

If VARIABLE was unset or null, it still is after this (no assignment done).

Or to assign default to VARIABLE at the same time:

`FOO="${VARIABLE:=default}"`  # If variable not set or null, set it to default.