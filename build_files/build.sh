#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Envision 3.2.0 missing build dependencies on top of Bazzite DX
# For "Lighthouse Driver - Envision Default"
## mesa-libGLU-devel from fedora satisfies pkgconfig(glu) but is filtered out by exclude filtering
dnf5 --setopt=disable_excludes=* install -y mesa-libGLU-devel
## mesa-libGL-devel from updates-archive satisfies mesa-libGL(x86-64) but is filtered out by exclude filtering
dnf5 --setopt=disable_excludes=* install -y mesa-libGL-devel
## Remaining dependencies provided by Envision missing dependencies error
dnf5 install -y eigen3-devel glslang-devel glslc libbsd-devel systemd-devel libusb1 libusb1-devel libXrandr-devel ninja-build openxr-devel SDL2-devel wayland-devel wayland-protocols-devel
# For "WiVRn - Envision Default"
## Fully replace ffmpeg-free with ffmpeg https://rpmfusion.org/Howto/Multimedia
dnf5 install -y --allowerasing --from-repo=rpmfusion-free,rpmfusion-free-updates,rpmfusion-nonfree,rpmfusion-nonfree-updates ffmpeg-devel
## x264-devel comes from RPM Fusion
dnf5 install -y --from-repo=rpmfusion-free,rpmfusion-free-updates,rpmfusion-nonfree,rpmfusion-nonfree-updates x264-devel
## bluez-libs-devel from fedora satisfies pkgconfig(bluez) but is filtered out by exclude filtering
dnf5 --setopt=disable_excludes=* install -y bluez-libs-devel
## Remaining dependencies packaged by Fedora
dnf5 install -y envision-wivrn

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
