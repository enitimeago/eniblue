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
# Workaround for
# > package sdl2-compat-devel-2.32.52-1.fc42.x86_64 from fedora requires pkgconfig(glu), but none of the providers can be installed
# > package mesa-libGLU-devel-9.0.3-6.fc42.x86_64 from fedora is filtered out by exclude filtering
dnf5 --setopt=disable_excludes=* install -y mesa-libGLU-devel
# Workaround for
# > package mesa-libGL-devel-25.1.9-1.fc42.x86_64 from updates-archive requires (mesa-libGL(x86-64) = 25.1.9-1.fc42 if mesa-libGL(x86-64)), but none of the providers can be installed
# > package mesa-libGL-25.1.9-1.fc42.x86_64 from updates-archive is filtered out by exclude filtering
dnf5 --setopt=disable_excludes=* install -y mesa-libGL-devel
# For "Lighthouse Driver - Envision Default" (excluding mesa-libGL-devel, since already installed above)
dnf5 install -y eigen3-devel glslang-devel glslc libbsd-devel systemd-devel libusb1 libusb1-devel libXrandr-devel ninja-build openxr-devel SDL2-devel wayland-devel wayland-protocols-devel
# For "WiVRn - Envision Default"
# (See https://rpmfusion.org/Howto/Multimedia regarding ffmpeg)
dnf5 install -y --allowerasing --from-repo=rpmfusion-free,rpmfusion-free-updates,rpmfusion-nonfree,rpmfusion-nonfree-updates ffmpeg-devel
dnf5 install -y --from-repo=rpmfusion-free,rpmfusion-free-updates,rpmfusion-nonfree,rpmfusion-nonfree-updates x264-devel
dnf5 install -y avahi-devel avahi-glib-devel boost-devel cli11-devel eigen3-devel glib2-devel glib2-devel glslang-devel gstreamer1-plugins-base-devel gstreamer1-devel libnotify-devel pipewire-devel systemd-devel librsvg2-devel libva-devel libXrandr-devel ninja-build json-devel openxr-devel patch systemd-devel

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
