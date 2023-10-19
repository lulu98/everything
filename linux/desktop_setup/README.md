# Desktop Setup

My personal desktop is based on a few applications to increase my productivity:

- `Ubuntu 22.04 LTS` as operating system
- `terminator` as terminal emulator
- `zsh` as Z Shell
- `vim` as text editor
- `i3wm` as window manager
- `i3blocks` as status bar

To setup `i3wm` proper use the following links:

- [i3wm setup](https://kifarunix.com/install-i3-windows-manager-on-ubuntu/)
- [i3blocks blocklets ideas](https://github.com/vivien/i3blocks-contrib)

You can find my current configuration files for different applications in the
`config` directory.

The picture `lock_screen.png` can be put into the `~/Pictures/` directory to be
used as a lock screen and wallpaper.

The config files to `zsh` and `vim` are dot-files and should be hidden in `~/`
but I want to have them visible in GitHub.

To use `brightnessctl` sudo app to control screen brightness in your i3
configuration, you have to add your user in the `/etc/sudoers` file to not
require a password (best use `sudo visudo` to edit this file):

```bash
lukas ALL=(ALL:ALL) NOPASSWD: /usr/bin/brightnessctl
```

