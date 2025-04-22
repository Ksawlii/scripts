#
# Copyright (C) 2025 Ksawlii
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

if [ -f "/etc/doas.conf" ] && [ -f "/usr/bin/doas" ]; then
    ROOT="doas"
elif [ -f "/usr/bin/sudo" ]; then
    ROOT="sudo"
else
    echo -e "ERROR: Doas and sudo not found. Install doas or sudo!"
    exit 1
fi

if grep -q "Ubuntu" /etc/os-release; then
  "$ROOT" apt update -qq
  "$ROOT" apt install lz4 brotli flex bc cpio kmod ccache zip binutils-aarch64-linux-gnu -y
elif grep -q "arch" "/etc/os-release"; then
  "$ROOT" pacman -Syyuu --needed  --noconfirm lz4 brotli flex bc cpio kmod ccache zip aarch64-linux-gnu-binutils
elif grep -q "gentoo" "/etc/os-release"; then
  "$ROOT" emerge -navq app-arch/lz4 app-arch/brotli sys-devel/flex sys-devel/bc app-arch/cpio sys-apps/kmod dev-util/ccache app-arch/zip sys-devel/crossdev
  "$ROOT" crossdev --target aarch64-linux-gnu
else
  echo -e "ERROR: Your distro is not Supported."
fi
