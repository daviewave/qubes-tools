# shellcheck shell=bash
# Source from ~/.bashrc:  . ~/qubes-tools/ali.sh
# QT_REPO points the repo-tool shortcuts at this checkout.

export QT_REPO="${QT_REPO:-$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)}"

#source bash
alias act='source ~/.bashrc'

#misc
alias la="ls -la"

export qdata=/var/lib/qubes

#-- qvm basics --#
alias ql="qvm-ls"
alias qlr="qvm-ls --running"
alias qln="qvm-ls --format network"
alias qld="qvm-ls --format disk"
alias qs="qvm-start"
alias qr="qvm-run"
alias qrr="qvm-run -u root"
alias qq="qvm-clone"
alias qcd="qvm-create --class DispVM --template"
alias qca="qvm-create --class AppVM --template"
alias qct="qvm-create --class TemplateVM --template"
alias qcp="qvm-copy-to-vm"
alias qf="qvm-firewall"
alias qp="qvm-prefs"
alias qup="qubes-prefs"
alias qd="qvm-shutdown"
alias qdw="qvm-shutdown --wait"
alias qda="qvm-shutdown --all --wait"
alias qk="qvm-kill"
alias qpa="qvm-pause"
alias qunp="qvm-unpause"
alias qrm="qvm-remove"

#-- qvm config --#
alias qfe="qvm-features"
alias qsv="qvm-service"
alias qtag="qvm-tags"
alias qvol="qvm-volume"
alias qpool="qvm-pool"
alias qdev="qvm-device"
alias qusb="qvm-device usb"
alias qblk="qvm-device block"

#-- templates / updates / backups --#
alias qtpl="qvm-template"
alias qdu="sudo qubes-dom0-update"
alias qvu="sudo qubes-vm-update"
alias qsync="qvm-sync-appmenus"
alias qbk="qvm-backup"
alias qbkr="qvm-backup-restore"

#-- qvm helpers --#
qterm() {
  [ -n "$1" ] || { echo "usage: qterm <vm> [user]"; return 1; }
  qvm-run -q -u "${2:-user}" "$1" qubes-run-terminal
}

qsh() {
  [ $# -ge 2 ] || { echo "usage: qsh <vm> <cmd...>"; return 1; }
  local vm=$1; shift
  qvm-run -p "$vm" "$*"
}

qrsh() {
  [ $# -ge 2 ] || { echo "usage: qrsh <vm> <cmd...>"; return 1; }
  local vm=$1; shift
  qvm-run -p -u root "$vm" "$*"
}

qrestart() {
  [ -n "$1" ] || { echo "usage: qrestart <vm>"; return 1; }
  qvm-shutdown --wait "$1" && qvm-start "$1"
}

qdisp() {
  local dvm=${1:-$(qubes-prefs default_dispvm)}
  qvm-run -q --dispvm="$dvm" "${2:-qubes-run-terminal}"
}

qnet() {
  [ -n "$1" ] || { echo "usage: qnet <vm>"; return 1; }
  local vm=$1 chain=$1
  while vm=$(qvm-prefs "$vm" netvm 2>/dev/null) && [ -n "$vm" ]; do
    chain="$chain -> $vm"
  done
  echo "$chain"
}

#-- repo tools --#
alias qrclocal='$QT_REPO/security/deploy_rc_local.sh'
alias qnft='$QT_REPO/networking/deploy_nft.sh'
alias qxml='$QT_REPO/security/d0/verify_vm_xml.sh'
alias qkali='$QT_REPO/qb-v2/kali-rpm-templates/pkg_setup_tools.sh'

#-- lsd --#
if command -v lsd > /dev/null; then
  alias lsd="sudo lsd -A --icon never"
  alias lsds="sudo lsd -A --icon never -Z"
  alias ez="sudo lsd -A --icon never --tree"
  alias ezz="sudo lsd -A --icon never --tree --depth"
  alias ezs="sudo lsd -A --icon never --tree -Z"
  alias ezzs="sudo lsd -A --icon never --tree -Z --depth"
fi

#-- micro --#
alias m="micro"


alias sctl="sudo systemctl"
alias jctl="sudo journalctl"
alias jf="sudo journalctl -f"
