# General notes on Ubuntu

Ubuntu is a Debian-based distribution with its own tooling on top. Most Debian knowledge applies, but there are important differences.

---

## Release Model

Ubuntu follows a predictable release schedule:

- **LTS (Long Term Support)**: Released every two years (e.g. 22.04, 24.04). Supported for 5 years standard, 10 years with Ubuntu Pro. **Use LTS for servers.**
- **Interim releases**: Released every 6 months, supported for 9 months only. Suitable for desktops and testing.

Check your release: `lsb_release -a`

---

## Package Management

Ubuntu uses `apt` like Debian, but adds:

- **Snap packages** — containerized applications managed by `snapd`. Snap is installed by default and used for some first-party tools (e.g. `lxd`, `multipass`, certbot).

```bash
snap list
snap install <package>
snap remove <package>
```

Snap packages run confined and update automatically. To disable auto-updates for a snap:

```bash
snap refresh --hold <package>
```

- **PPAs (Personal Package Archives)** — third-party apt repositories hosted on Launchpad:

```bash
add-apt-repository ppa:user/repo
apt update
```

---

## Networking — Netplan

Ubuntu uses **Netplan** instead of `/etc/network/interfaces`. Configuration files live in `/etc/netplan/` and are written in YAML.

Example static IP configuration (`/etc/netplan/01-netcfg.yaml`):

```yaml
network:
  version: 2
  ethernets:
    ens3:
      addresses:
        - 192.168.1.10/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

Apply changes: `netplan apply`  
Test before applying: `netplan try` (reverts after 120 seconds if not confirmed)

---

## Firewall — UFW

Ubuntu ships with `ufw` (Uncomplicated Firewall) as a front-end for iptables/nftables.

```bash
ufw enable
ufw status verbose
ufw allow ssh
ufw allow 80/tcp
ufw deny 23/tcp
ufw delete allow 80/tcp
```

UFW is disabled by default on fresh installs.

---

## cloud-init

Ubuntu cloud images use **cloud-init** to configure instances at first boot. Configuration is typically provided via user-data (on cloud providers or via nocloud datasource for on-prem VMs).

Useful commands:

```bash
cloud-init status           # check initialization status
cloud-init query userdata   # view the user-data that was applied
cloud-init clean            # reset to re-run on next boot (for testing)
```

Cloud-init logs: `/var/log/cloud-init.log` and `/var/log/cloud-init-output.log`

---

## Major Version Upgrades

Use `do-release-upgrade` to upgrade between LTS versions:

```bash
apt update && apt upgrade
do-release-upgrade
```

Before upgrading: snapshot the VM, ensure backups are current, and check the release notes for known issues with your workload.

---

## Ubuntu Pro

Ubuntu Pro extends security patching to the `universe` repository and adds kernel live-patching (Livepatch). Available free for personal use (up to 5 machines).

```bash
pro attach <token>
pro status
pro enable livepatch
```

---

## VM Tools

Install the appropriate guest agent depending on your hypervisor:

- VMware: `open-vm-tools`
- VirtualBox: `virtualbox-guest-utils`
- KVM/QEMU: `qemu-guest-agent`
- Hyper-V: included in the kernel since Ubuntu 18.04

---

## Common Packages

#### Base

- `curl`, `wget`, `git`, `vim`, `gnupg`
- `build-essential` — GCC, make, and standard headers for building from source
- `ca-certificates`, `apt-transport-https`
- `sudo`, `adduser`

#### Administration

- `mc`, `htop`, `tmux`, `screen`
- `net-tools`, `iproute2`, `bind9-dnsutils`
- `tcpdump`, `nmap`, `ngrep`, `netcat`
- `lsb-release`, `unattended-upgrades`

#### Security

- `fail2ban`
- `ufw`
- `auditd`
- `tripwire`
- `libpam-google-authenticator` — for TOTP-based MFA on SSH

---

## Automatic Security Updates

Enable unattended security updates:

```bash
apt install unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades
```

Configuration file: `/etc/apt/apt.conf.d/50unattended-upgrades`
