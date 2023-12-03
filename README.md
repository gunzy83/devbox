# devbox

## Description

**devbox** is my opinionated [distrobox](https://distrobox.it/) container image. It is designed to be my default shell and provide desktop applications for development and keep my base system clean. This is particularly important if you are using an operating system like Fedora Silverblue/Kinoite.

It is inspired by [boxkit](https://github.com/ublue-os/boxkit) and is intended to compliment my [dotfiles](https://github.com/gunzy83/dotfiles) repo.

## How to use

### Create a distrobox.ini

Create a distrobox.ini file in your home directory based on the below:

```ini
[devbox]
image=ghcr.io/gunzy83/devbox:latest
init=false
nvidia=false
root=false
start_now=true

# export apps
init_hooks=sudo -u $USER CONTAINER_ID=devbox distrobox-export --app code;
init_hooks=sudo -u $USER CONTAINER_ID=devbox distrobox-export --app subl;
init_hooks=sudo -u $USER CONTAINER_ID=devbox distrobox-export --app lens-desktop;
init_hooks=sudo -u $USER CONTAINER_ID=devbox distrobox-export --app inkdrop;

# fix desktop matching
init_hooks=ln -sf ~/.local/share/applications/devbox-sublime_text.desktop ~/.local/share/applications/sublime_text.desktop;
init_hooks=ln -sf ~/.local/share/applications/devbox-code.desktop ~/.local/share/applications/code.desktop;

# map to apps on the host
init_hooks=ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/wavebox;
init_hooks=ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/op;

# ubuntu/debian specifics
init_hooks=ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/apt;
init_hooks=ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/apt-get;
init_hooks=ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/dpkg;

# fedora host specifics
init_hooks=ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree;
init_hooks=ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update;

# environment variables
additional_flags="--env BROWSER=/usr/local/bin/wavebox --env LANG=en_AU.UTF-8 --env GTK_MODULES=unity-gtk-module";
```

### Assemble or Upgrade the distrobox

To assemble or upgrade the distrobox run the following command:

```bash
distrobox assemble create --replace --file distrobox.ini
```

## License

BSD 2-Clause License

## Author Information

Copyright 2023 [Ross Williams](http://rosswilliams.id.au/).

