# NOTE

If your `~/.profile` contains:

```
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
```

Then we can easily use this to place any binaries under our `$HOME/bin`.

This is what the scripts do.


# ISSUES

## Nodejs

The script keeps the `$HOME/bin/node` binary always to the version you have last chosen on the script parameter.

# USAGE

- `./nodejs.bash -v 16.17.0`
- `./ansible.bash -v 6.5.0 -u eosantigen`

