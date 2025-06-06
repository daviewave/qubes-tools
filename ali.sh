#source bash
alias act="source /home/$USER/.bashrc"

#misc
alias la="ls -la"

export qdata=/var/lib/qubes

alias ql="qvm-ls"
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
alias qrm="qvm-remove"
#-- lsd --#
alias lsd="sudo lsd -A --icon never"
alias lsds="sudo lsd -A --icon never -Z"
alias ez="sudo lsd -A --icon never --tree"
alias ezz="sudo lsd -A --icon never --tree --depth"
alias ezs="sudo lsd -A --icon never --tree -Z"
alias ezzs="sudo lsd -A --icon never --tree -Z --depth"

#-- micro --#
alias m="micro"


alias sctl="sudo systemctl"
