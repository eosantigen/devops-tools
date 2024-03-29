#### cleanup syslog
`sudo journalctl --vacuum-size=50M / --vacuum-time=1d`

#### base64 encode / decode:
`echo -n "geonode" | base64`
`echo -n "Z2Vvbm9kAF==" | base64 -d`

#### find text across subdirectories
`grep -r "string" /path`

#### replace string across subdirectories
```bash
# as dry-run at first...to check how many entries will be changed.
grep -rli changeme . | grep -Ev "exluded_output" | xargs sed -i s/changeme/test/g | wc -l

# without the dry-run, to actually do the replacement. 
grep -rl changeme . | grep -Ev "exluded_output" | xargs sed -i s/changeme/test/g
```
#### visudo / sudoers
```bash
# Members of the admin group may gain root privileges

%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command

%sudo ALL=(ALL:ALL) /usr/bin/pip3, /usr/bin/git, !/bin/su

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d

%jupyterhub ALL= NOEXEC: /usr/bin/sudo, /usr/bin/pip3
```

#### Use another server to send email:
```sh
ssh -i $HOME/.ssh/${ssh_user} ${ssh_user}@${email_server} "echo -e 'Subject: ${email_message_subject}' '\n$@' | sendmail ${email_to}"
```

## BASH

#### Use of $HOME/bin
If your `~/.profile` contains:
```bash
# set PATH so it includes user's private bin if it exists

if [ -d "$HOME/bin" ] ; then

PATH="$HOME/bin:$PATH"

fi
```

Then we can easily use this to place any binaries under our `$HOME/bin`.

#### Grab dynamically the repo base name
```bash
PROJECT_NAME=`basename -s 'git@github.com:eosantigen/' -s '.git' $(git remote get-url origin --all)`
```

#### Default variable values
To get the assigned value, or default if it's missing:

`FOO="${VARIABLE:-default}"` # If variable was unset or null, use default.

If VARIABLE was unset or null, it still is after this (no assignment done).

Or to assign default to VARIABLE at the same time:

`FOO="${VARIABLE:=default}"` # If variable not set or null, set it to default.