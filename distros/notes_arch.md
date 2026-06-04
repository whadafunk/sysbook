# General notes on Arch Linux

Arch Linux is a rolling-release distribution targeting experienced users. There are no major version upgrades — the system is continuously updated. The [Arch Wiki](https://wiki.archlinux.org) is among the best Linux documentation resources available and covers almost every topic in detail.

---

## Package Management — pacman

```bash
pacman -Syu                   # sync and upgrade all packages
pacman -S <package>           # install
pacman -R <package>           # remove (keep dependencies)
pacman -Rs <package>          # remove with unneeded dependencies
pacman -Ss <keyword>          # search
pacman -Qi <package>          # installed package info
pacman -Ql <package>          # list files installed by package
pacman -Qo /path/to/file      # which package owns a file
pacman -Qdt                   # list orphaned packages
pacman -Sc                    # clean package cache
```

### Mirrors

Mirror quality directly affects update speed. Use `reflector` to auto-select fast mirrors:

```bash
pacman -S reflector
reflector --country <Country> --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
```

Or run it as a service that updates mirrors after each network connection:

```bash
systemctl enable reflector.service
```

---

## AUR — Arch User Repository

The AUR contains community-maintained build scripts (PKGBUILDs) for packages not in the official repos. Use an AUR helper to manage them — `paru` and `yay` are the most popular.

**Install paru:**

```bash
pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si
```

**Usage (same syntax as pacman for most operations):**

```bash
paru -Syu                     # upgrade including AUR packages
paru -S <aur-package>
paru -Ss <keyword>            # search official repos and AUR
```

Always review the PKGBUILD before installing from the AUR.

---

## Rolling Release

Arch has no release versions — you are always on "current." This means:

- `pacman -Syu` should be run regularly; long delays between updates increase the risk of partial upgrades
- **Never do a partial upgrade** (`pacman -Sy` without `-u`) — it can break the system by mixing library versions
- Check the [Arch Linux news feed](https://archlinux.org/news/) before upgrading; manual intervention is occasionally required
- Subscribe to the `arch-announce` mailing list or use the `informant` AUR package to be notified of required manual steps

---

## Networking

Arch has no default network manager. Common choices:

- **NetworkManager** — recommended for desktops and laptops with WiFi:
  ```bash
  pacman -S networkmanager
  systemctl enable --now NetworkManager
  nmcli device wifi connect <SSID> password <pass>
  ```

- **systemd-networkd** — lightweight, good for servers:
  ```bash
  # /etc/systemd/network/20-wired.network
  [Match]
  Name=ens3

  [Network]
  Address=192.168.1.10/24
  Gateway=192.168.1.1
  DNS=8.8.8.8
  ```
  ```bash
  systemctl enable --now systemd-networkd systemd-resolved
  ```

---

## initramfs — mkinitcpio

Arch uses `mkinitcpio` to generate the initial ramdisk. After certain system updates (e.g. kernel updates) it is rebuilt automatically. To rebuild manually:

```bash
mkinitcpio -P                 # rebuild all presets
```

Configuration: `/etc/mkinitcpio.conf` — defines hooks and modules included in the initramfs.

---

## Bootloader

The most common bootloader on Arch is **GRUB** or **systemd-boot**.

GRUB regenerate config after kernel update:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

systemd-boot auto-detects kernels in `/boot/vmlinuz-*` — no regeneration needed.

---

## Services — systemd

```bash
systemctl start|stop|restart <service>
systemctl enable|disable <service>
systemctl status <service>
systemctl list-units --type=service --state=running
journalctl -xe                # view recent journal errors
journalctl -u <service> -f    # follow a service's logs
```

---

## Firewall

Arch does not configure a firewall by default. Install and enable one:

```bash
pacman -S ufw
ufw enable
ufw allow ssh
ufw status verbose
```

Or use `nftables` directly (the kernel's native packet filtering framework):

```bash
pacman -S nftables
systemctl enable --now nftables
```

---

## VM Tools

- VMware: `open-vm-tools` (from AUR or official repo)
- VirtualBox: `virtualbox-guest-utils`
- KVM/QEMU: `qemu-guest-agent`

---

## Common Packages

#### Base (not included by default)

- `base-devel` — GCC, make, binutils, required for building AUR packages
- `man-db`, `man-pages`, `texinfo`
- `git`, `vim`, `curl`, `wget`
- `sudo` — and add your user to the `wheel` group; uncomment `%wheel ALL=(ALL:ALL) ALL` in visudo

#### Administration

- `mc`, `htop`, `btop`, `tmux`
- `net-tools`, `iproute2`, `bind-tools`
- `tcpdump`, `nmap`, `ngrep`, `gnu-netcat`
- `lsof`, `strace`, `ltrace`

#### Security

- `ufw` or `nftables`
- `fail2ban`
- `gnupg`
- `openssh`

---

## Pacnew / Pacsave Files

After upgrades, pacman may create `.pacnew` files when a config file it owns has been locally modified. You must review and merge these manually:

```bash
find /etc -name "*.pacnew" 2>/dev/null
```

Use `pacdiff` (from the `pacman-contrib` package) to diff and merge them:

```bash
pacman -S pacman-contrib
pacdiff
```
