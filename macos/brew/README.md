# Brewconfig

This is a brew bundle file that contains all the packages I use on my Mac. 
It is a simple way to install all the packages I need on a new Mac.

## How to use

1. Install Homebrew and confirm it is installed correctly.
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Run the following command to install all the packages in the Brewfile.
```bash
brew bundle --file=./Brewfile
```


