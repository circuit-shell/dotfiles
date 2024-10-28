## Update symbolic links

- Commands below will create all the files if they don't yet exist if they do
  exist, it will update them.
- `-n` allows the link to be treated as a normal file if it is a symlink to a
  directory
- `-f` "force" overwrites without warning if it already exists

## Point your `~/.zshrc` file to the desired repo

```bash
ln -snf ~/github/dotfiles-latest/zshrc/zshrc-file.sh ~/.zshrc >/dev/null 2>&1
source ~/.zshrc
```
