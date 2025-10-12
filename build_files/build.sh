#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Envision 3.2.0 missing build dependencies on top of Bazzite DX
# For "Lighthouse Driver - Envision Default"
dnf5 install -y eigen3-devel glslang-devel glslc libbsd-devel systemd-devel libusb1 libusb1-devel libXrandr-devel mesa-libGL-devel ninja-build openxr-devel SDL2-devel wayland-devel wayland-protocols-devel
# For "WiVRn - Envision Default"
dnf5 install -y avahi-devel avahi-glib-devel cli11-devel eigen3-devel glib2-devel glib2-devel glslang-devel gstreamer1-plugins-base-devel gstreamer1-devel ffmpeg-devel ffmpeg-devel ffmpeg-devel libnotify-devel pipewire-devel ffmpeg-devel systemd-devel libva-devel libXrandr-devel ninja-build json-devel openxr-devel patch systemd-devel x264-devel

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
