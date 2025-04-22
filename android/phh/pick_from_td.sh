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

REPO="$1"
START_COMMIT="$2"
END_COMMIT="$3"

if [ -z "$REPO" ] || [ -z "$START_COMMIT" ]; then
  echo "USAGE: PICK_COMMITS [PATH] [COMMIT_HASH] [COMMIT_HASH]"
  echo "WARNING: Don't put '/' in the end of path name"
  return 1
fi

if [ -z "$END_COMMIT" ]; then
  END_COMMIT="$START_COMMIT"
fi

if [ ! -d "$REPO" ]; then
  echo "ERROR: Path not found: $REPO"
  return 1
fi

TD_REPO="${REPO//\//_}"
cd "$REPO" || return 1

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "ERROR: $REPO is not a Git repository"
  return 1
fi

if ! git remote | grep -q "^td$"; then
  if [ ! "$1" = "build/make" ]; then
    git remote add "td" "https://github.com/TrebleDroid/platform_$TD_REPO.git"
  else
    git remote add "td" "https://github.com/TrebleDroid/platform_build.git"
  fi
fi
  
git fetch "td" --no-tags

if [ "$START_COMMIT" = "$END_COMMIT" ]; then
  git cherry-pick "$START_COMMIT"
else
  git cherry-pick "$START_COMMIT^..$END_COMMIT"
fi
