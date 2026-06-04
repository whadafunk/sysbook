# General notes on Rocky Linux / RHEL

Rocky Linux is a community enterprise distribution built from RHEL sources, intended as a drop-in replacement for CentOS. Notes here apply to Rocky Linux 8/9, AlmaLinux, and RHEL with minor differences.

---

## Package Management — dnf

Rocky Linux uses `dnf` (Dandified YUM), the modern replacement for `yum`. The `yum` command still works as an alias.

```bash
dnf update
dnf install <package>
dnf remove <package>
dnf search <keyword>
dnf info <package>
dnf list installed
dnf history                  # view transaction history
dnf history undo <id>        # roll back a transaction
```

### Repositories

```bash
dnf repolist
dnf repolist all              # includes disabled repos
dnf config-manager --enable <repo>
```

**EPEL (Extra Packages for Enterprise Linux)** — the most important third-party repo:

```bash
dnf install epel-release
```

For Rocky 9, also enable CRB (CodeReady Linux Builder) for build dependencies:

```bash
dnf config-manager --set-enabled crb
```

### RPM basics

```bash
rpm -qa                       # list all installed packages
rpm -qi <package>             # package info
rpm -ql <package>             # list files installed by package
rpm -qf /path/to/file         # which package owns a file
```

---

## Firewall — firewalld

Rocky Linux uses `firewalld` with zone-based policy. The default zone for most interfaces is `public`.

```bash
firewall-cmd --state
firewall-cmd --get-active-zones
firewall-cmd --zone=public --list-all
firewall-cmd --zone=public --add-service=ssh --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload
```

Always use `--permanent` and then `--reload` to make changes survive reboots.

---

## SELinux

SELinux is enabled and in **enforcing** mode by default. Do not disable it — learn to work with it.

```bash
getenforce                    # Enforcing / Permissive / Disabled
sestatus                      # detailed status
setenforce 0                  # temporary permissive mode (for debugging)
```

Check SELinux denials:

```bash
ausearch -m avc -ts recent
sealert -a /var/log/audit/audit.log
```

Manage file contexts:

```bash
ls -Z /path                   # show SELinux context
chcon -t httpd_sys_content_t /var/www/html/file    # change context
restorecon -Rv /var/www/html/                      # restore default context
```

Manage booleans:

```bash
getsebool -a                  # list all booleans
setsebool -P httpd_can_network_connect on          # set permanently
```

---

## Services — systemd

Rocky Linux uses systemd like most modern Linux distributions.

```bash
systemctl start|stop|restart|reload <service>
systemctl enable|disable <service>
systemctl status <service>
systemctl list-units --type=service
journalctl -u <service> -f    # follow logs for a service
```

---

## Networking — NetworkManager

Rocky Linux uses NetworkManager by default. Use `nmcli` to configure network interfaces.

```bash
nmcli device status
nmcli connection show
nmcli connection modify <name> ipv4.addresses 192.168.1.10/24
nmcli connection modify <name> ipv4.gateway 192.168.1.1
nmcli connection modify <name> ipv4.dns "8.8.8.8 1.1.1.1"
nmcli connection modify <name> ipv4.method manual
nmcli connection up <name>
```

Connection profiles are stored as ini-style files under `/etc/NetworkManager/system-connections/`.

---

## Cockpit

Rocky Linux ships with **Cockpit**, a web-based admin interface. It provides server monitoring, service management, storage, networking, and a terminal.

```bash
dnf install cockpit
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload
```

Access at `https://<host>:9090`

---

## Podman (vs Docker)

Rocky Linux defaults to **Podman** instead of Docker. Podman is daemonless and supports rootless containers.

```bash
podman pull <image>
podman run -d -p 80:80 <image>
podman ps
podman images
podman stop|rm <container>
podman generate systemd --new <container>   # generate a unit file
```

Docker CE can be installed from the Docker repository if needed, but Podman is preferred for RHEL-family systems.

---

## RHEL Subscriptions

If running RHEL (not Rocky/Alma), the system must be registered to receive updates:

```bash
subscription-manager register --username <user> --password <pass>
subscription-manager attach --auto
subscription-manager status
```

---

## VM Tools

- VMware: `open-vm-tools`
- VirtualBox: `virtualbox-guest-additions` (from EPEL or VirtualBox repo)
- KVM/QEMU: `qemu-guest-agent`
- Hyper-V: built into the kernel

---

## Common Packages

#### Base

- `curl`, `wget`, `git`, `vim`, `gnupg2`
- `tar`, `unzip`, `bzip2`
- `ca-certificates`
- `sudo`, `shadow-utils`

#### Administration

- `mc`, `htop`, `tmux`
- `net-tools`, `iproute`, `bind-utils`
- `tcpdump`, `nmap`, `ngrep`, `ncat`
- `lsof`, `strace`

#### Security

- `fail2ban` (from EPEL)
- `firewalld` (default)
- `audit`, `auditd`
- `policycoreutils-python-utils` — SELinux tools (`semanage`, `audit2allow`, `sealert`)
