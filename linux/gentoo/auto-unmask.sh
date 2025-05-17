if [ "$#" -lt 2 ]; then
  echo "Usage: $0 [package_group] [package]"
  echo "Example: $0 www-client firefox"
  exit 1
fi

if [ -f "/etc/doas.conf" ] && "command" -v "doas" &>/dev/null; then
  ROOT="doas"
elif "command" -v "sudo" &</dev/null; then
  ROOT="sudo"
else
  echo "ERROR: Doas and sudo not found. Install doas or sudo!"
  exit 1
fi

I="${1}/${2} ~amd64"
PCK_KEYWORDS="/etc/portage/package.accept_keywords"

[ ! -d "$PCK_KEYWORDS" ] && "$ROOT" mkdir -p "$PCK_KEYWORDS"

if ! grep -Fxq "$I" "$PCK_KEYWORDS/$1" 2>/dev/null; then
  [ ! -f "$PCK_KEYWORDS/$1" ] && "$ROOT" touch "$PCK_KEYWORDS/$1"
  echo "$I" | "$ROOT" tee -a "$PCK_KEYWORDS/$1" > /dev/null
fi
