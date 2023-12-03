#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

dnf -y update
dnf -y upgrade

# Preinstall basic packages required by distrobox
dnf -y install bash-completion bc bzip2 curl diffutils dnf-plugins-core \
  findutils git glibc-all-langpacks glibc-locale-source gnupg2 gnupg2-smime \
  hostname iproute iputils jq keyutils krb5-libs less lsof man-db man-pages \
  mesa-dri-drivers mesa-vulkan-drivers mtr ncurses nss-mdns openssh-clients \
  pam passwd pigz pinentry procps-ng rsync shadow-utils sudo tcpdump time \
  traceroute tree tzdata unzip util-linux vte-profile vulkan wget which whois \
  words xorg-x11-xauth xz zip zsh

chmod +x /tmp/files/scripts/*.sh

# Preinstall host spawn
/tmp/files/scripts/host-spawn-install.sh

# Install asdf inside the container image
/tmp/files/scripts/asdf-install.sh

cd /tmp/files/

# Install etc files
cp -r etc /etc

# Prepare dnf repos
yq -r '.copr[]' packages.yaml | xargs -I{} dnf -y copr enable {}
yq -r '.repos[].gpg | select( . != null )' packages.yaml | xargs -I{} rpm -v --import {}
yq -r '.repos[].url | select( . != null )' packages.yaml | xargs -I{} dnf -y config-manager --add-repo "{}"
eval "$(yq -r '.repos[] | select( .content != null ) | .command = "cat <<EOF >| /etc/yum.repos.d/" + .name + ".repo\n" + .content + "\nEOF" | .command' packages.yaml)"

# Install packages
dnf -y check-update
dnf -y install $(yq -r '.packages | join(" ")' packages.yaml)

install_rpm() {
  curl -SL -o /tmp/$1 $2
  rpm -i /tmp/$1 --excludepath=/usr/lib/.build-id
  rm /tmp/$1
}

# Install RPMs
eval "$(yq -r '.rpms[] | .command = "install_rpm " + .name + " " + .download | .command' packages.yaml)"

mkdir -p /tmp/installs

install_binary() {
  cd "$(mktemp -d -p /tmp/installs)"
  curl -sL $2 | tar xz
  mv $1 /usr/local/bin
}

# Install binaries
eval "$(yq -r '.binaries[] | .command = "install_binary " + .name + " " + .archive | .command' packages.yaml)"

# Cleanup
rm -rf /tmp/installs
dnf clean all

