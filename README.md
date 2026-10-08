# qubes-tools

Personal Qubes OS shortcuts, hardening scripts and template-building helpers.
Each tool says where it runs: **dom0**, a **template**, or inside a **qube**.

## Shortcuts — `ali.sh` (dom0)

Source it from `~/.bashrc`:

```bash
. ~/qubes-tools/ali.sh
```

`QT_REPO` defaults to the directory `ali.sh` lives in; the repo-tool shortcuts use it.

| Group | Shortcuts |
| --- | --- |
| list | `ql`, `qlr` (running), `qln` (network), `qld` (disk) |
| lifecycle | `qs`, `qd`, `qdw` (wait), `qda` (all), `qk`, `qpa`, `qunp`, `qrestart <vm>` |
| create / copy | `qq`, `qca`, `qcd`, `qct`, `qcp`, `qrm` |
| run | `qr`, `qrr` (root), `qsh <vm> <cmd>`, `qrsh <vm> <cmd>`, `qterm <vm> [user]`, `qdisp [dvm] [cmd]` |
| config | `qp`, `qup`, `qf`, `qfe`, `qsv`, `qtag`, `qvol`, `qpool`, `qdev`, `qusb`, `qblk` |
| inspect | `qnet <vm>` — prints the netvm chain, e.g. `work -> sys-firewall -> sys-net` |
| updates / backups | `qdu` (dom0), `qvu` (qubes), `qtpl`, `qsync`, `qbk`, `qbkr` |
| repo tools | `qrclocal`, `qnft`, `qxml`, `qkali` (see below) |
| misc | `act`, `la`, `m`, `sctl`, `jctl`, `jf`, `lsd`/`ez*` (when lsd is installed) |

## dom0

| Tool | What it does |
| --- | --- |
| `security/deploy_rc_local.sh <vm> <debian\|fedora\|file> [--run]` | Pushes an rc.local into the qube's `/rw/config/rc.local` (backs up the old one, refuses files that fail `bash -n`). |
| `networking/deploy_nft.sh <vm> <ruleset.nft> [--apply]` | Installs a ruleset under `/rw/config/nft/`, has the qube's `nft -c` validate it, and adds a `qubes-firewall.d` hook so it reloads on every start. |
| `security/d0/verify_vm_xml.sh <baseline\|check> [vm...]` | Records each libvirt domain's persistent XML, then reports `CHANGED` / `NEW` / `MISSING` domains. Re-baseline after intended changes. |
| `security/d0/ensure_no_xml_tampering.sh [vm...]` | Dumps domain XML to `./vm-xmls` (or `$XML_DIR`) with the hardening edits applied. |
| `security/d0/convert-to-btrfs-subvol.sh [--backup] [--dry-run]` | Turns each qube dir under `/var/lib/qubes/{appvms,vm-kernels,vm-templates,backup}` into a btrfs subvolume. All qubes must be shut down. |
| `security/d0/configure_authselect.sh` | Local authselect profile with hardening features; prunes `/etc/pam.d` to a keep list (tarball backup in `/root`). |
| `security/d0/secure_dom0.sh` | Removes remote-access packages and configs. Refuses to run on an `lvm_thin` pool because it removes lvm2. |
| `qb-v2/kali-rpm-templates/pkg_setup_tools.sh <a\|t> [vm]` | Packages the Kali builder tools into `transfer-pkgs/<type>-setup-tools` and optionally copies them to a qube. |

## Templates and qubes

| Tool | What it does |
| --- | --- |
| `initial-vms-setup/install_vscode.sh [fedora\|debian]` | Adds the Microsoft repo and installs VS Code (distro auto-detected). |
| `initial-vms-setup/install_mullvad_browser.sh [fedora\|debian]` | Adds the Mullvad repo and installs Mullvad Browser. |
| `initial-vms-setup/starter/setup.sh` | sysctl hardening (`conf/90-qubes-hardening.conf`), module blacklist, pam_access/faillock, SELinux booleans. |
| `initial-vms-setup/starter/verify.sh` | Checks that everything `setup.sh` set is actually in effect; exits non-zero on any failure. |
| `initial-vms-setup/usage/setup.sh [user] [admin]` | Users, SELinux login mappings, grub defaults. `scripts/restrict_access.sh` is optional. |
| `security/qubes/configure_authselect.sh` | Same as the dom0 version, but keeps `qrexec`. |
| `security/qubes/setup_nss_db.sh [--switch]` | Builds nss_db files and checks that they resolve; `--switch` points nsswitch at them. Rebuild after any user change. |
| `security/rc.local-{debian,fedora}` | Per-boot debloat and cleanup; deploy with `deploy_rc_local.sh`. |
| `networking/qubes-setup-dnat-to-ns` | dhcpcd hook in sys-net that DNATs the qube DNS addresses to the upstream resolvers. |

## Kali template builder (`qb-v2/kali-rpm-templates`)

In the Debian build template, under `/opt/t-setup-tools/helper-tools`:

1. `MAIN_prepare_templatevm.sh` runs steps `01`–`06`. Each step sources `envs.sh` itself.
2. `build_template.sh [template] [--sign]` builds (default `kali-core`) with qubes-builderv2.
3. `clean_wrkdir.sh [artifact-dir]` clears build artifacts and prunes docker.

`transfer-pkgs/` is generated output from `pkg_setup_tools.sh`; the committed copy
predates the current helper tools, so regenerate it before copying it to a qube.

## Linting

```bash
./lint.sh
```

Runs `bash -n`, `shellcheck` (when installed), `nft -c` (in an unprivileged
netns) and a Python parse over every tracked script.
