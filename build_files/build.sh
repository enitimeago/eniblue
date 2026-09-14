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

# WiVRn 26.9 from testing
# At time of writing stable is 26.6.2 which is incompatible with 26.9 client
dnf5 install -y wivrn wivrn-dashboard --enablerepo=updates-testing

### Manual installs

# Rust toolchain
dnf5 install -y cargo
export CARGO_HOME=/tmp/cargo
mkdir -p "$CARGO_HOME/bin"
PATH="$PATH:$CARGO_HOME/bin"

# Monado Tracking Origin Calibrator (motoc)
dnf5 install -y openxr-devel
# renovate: datasource=github-tags depName=galister/motoc
MOTOC_VERSION="v0.4.0"
cargo install --locked --git https://github.com/galister/motoc.git --tag "${MOTOC_VERSION}" motoc
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
