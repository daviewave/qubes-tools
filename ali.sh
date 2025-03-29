#source bash
alias act="source /home/$USER/.bashrc"

#misc
alias la="ls -la"

#qube 
export usb1=/mnt/1
export usb2=/mnt/2
export usb3=/mnt/3
export usb4=/mnt/4
export usb5=/mnt/5

export qdata=/var/lib/qubes
export qtools=qubes_setup_tools

alias ql="qvm-list"
alias qs="qvm-start"
alias qr="qvm-run"
alias qrr="qvm-run -u root"
alias qr="qvm-run"
alias qq="qvm-clone"
alias qca="qvm-create --class DispVM --template"
alias qca="qvm-create --class AppVM --template"
alias qca="qvm-create --class TemplateVM --template"
alias qcopy="qvm-copy-to-vm"
alias qf="qvm-firewall"
alias qvp="qvm-prefs"
alias qp="qubes-prefs"
alias qrm="qvm-shutdown"
alias qrm="qvm-remove"
