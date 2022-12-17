# Stop All Pending Builds

In [https://jenkins.devanet/script](https://jenkins.devanet/script "https://jenkins.devanet/script") run this : `Jenkins.instance.queue.clear()`

# Update SSL Certificate

First remove existing pfx/jks files in `/var/lib/jenkins/keys/`

Be careful with the selection of the domain names when changing between different servers, although the wildcard certificate would have no issue .

Use the same pass on every prompt!

The -name must be the FQDN of Jenkins and not the hostname.

```
openssl pkcs12 -export -out jenkins.devanet.pfx -passout 'pass:same_pass_for_all_please' -inkey wildcard.key -in wildcard.crt -certfile wildcard.ca-bundle -name jenkins.devanet

keytool -importkeystore -srckeystore jenkins.devanet.pfx -srcstoretype pkcs12 -destkeystore jenkins.devanet.jks -deststoretype JKS
```

(In case the path/file names have been changed, then, at `/etc/default/jenkins` edit the parameters to add the new path and finally, `systemctl restart jenkins`)

# Base OS & Jenkins Upgrades

After the Ubuntu upgrade, make sure that `/etc/apt/sources.list.d/jenkins.list` is active by checking the repositories in it are without comments.

## Changing the base URL

`jenkins.model.JenkinsLocationConfiguration.xml` contains the base url which can also be modified from the UI, and needs to be changed before changing it on BitBucket OAUTH Callback URL. _(in case of needing to change the url)_

## Disable BitBucket OAuth (in case it’s necessary)

In `/var/lib/jenkins/config.xml`

Comment out this:
```
<securityRealm class="org.jenkinsci.plugins.BitbucketSecurityRealm">
<clientID>...</clientID>
<secretClientSecret>...</secretClientSecret>
</securityRealm>
```
and change this `<useSecurity>true</useSecurity>` to **false .** Then, disable the plugin inside `/var/lib/jenkins/plugins/` by running:

`touch bitbucket-oauth.jpi.disabled && systemctl restart jenkins`

You can now enter Jenkins UI.