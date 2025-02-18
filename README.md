# 🇬🇧 shell brit 🇬🇧

based on [sudofox/shell-mommy](https://github.com/sudofox/shell-mommy)

this is a shell script that provides a `brit` function which emulates a bad-tempered brit in your shell. the `brit` function can be used to offer either insults or love, depending on the exit status of the command that is passed to it.

this will probably not improve your efficiency in any way, have fun

## installation

to use the `brit` function, you can source the `shell-brit.sh` script in your current shell or add it to your `~/.bashrc` file to have it available every time you open a new terminal.

```sh
. /path/to/shell-brit.sh
```

if you'd like it to always show a message after each command, you can define a custom `PROMPT_COMMAND` like so:

```sh
export PROMPT_COMMAND="brit \\$\\(exit \$?\\); $PROMPT_COMMAND"
```

## usage

to use the `brit` function, simply pass a command as an argument and `brit` will provide a snarky response based on the exit status of the command. depending on the exit status, `brit` will provide a response of begrudging praise or scorn.

```sh
brit ls
# output: absolutely smashing, well done mate!

brit this-command-does-not-exist
# output: bet you can't even organise a piss-up in a brewery.
```
