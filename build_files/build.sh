#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# LACT
dnf5 -y copr enable ilyaz/LACT
dnf5 install -y lact
systemctl enable lactd

# WiVRn
dnf5 install -y wivrn wivrn-dashboard

### Manual installs

# Rust toolchain
dnf5 install -y cargo
export CARGO_HOME=/tmp/cargo
mkdir -p "$CARGO_HOME/bin"
PATH="$PATH:$CARGO_HOME/bin"

# Monado Tracking Origin Calibrator (motoc)
dnf5 install -y openxr-devel
cargo install --locked --git https://github.com/galister/motoc.git
cp "$CARGO_HOME/bin/motoc" /usr/bin/

# Cleanup Rust toolchain and replace with rustup for end users
dnf5 remove -y cargo
dnf5 install -y rustup

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
