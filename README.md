# The big bad book of system administration practices

![Cover Photo](./cover_photo.jpg)

A curated, opinionated reference for system administrators working with Linux-based infrastructure. This book collects best practices, actionable checklists, naming conventions, software catalogs, and ITSM guidelines into one place — no fluff, just operational knowledge.

**Audience:** Sysadmins and infrastructure engineers managing servers, VMs, and containers in on-premises or hybrid environments.

---

## Contents

### ITSM Practices

| Document | Description |
|---|---|
| [Sysadmin Practices](./itsm-practices/sysadmin_practices.md) | Foundational principles every sysadmin should follow |
| [VM Practices](./itsm-practices/vm_practices.md) | Virtual machine configuration and management |
| [Naming Conventions](./itsm-practices/naming_practices.md) | Network equipment, infrastructure, and VLAN naming schemas |
| [Documentation Layout](./itsm-practices/documentation_layout.md) | Standard structure for infrastructure documentation |

### Checklists

| Document | Description |
|---|---|
| [Server Checklist](./checklist_server.md) | Provisioning and hardening a new server (Debian-based) |
| [Desktop Checklist](./checklist_desktop.md) | Setting up a desktop environment |
| [Container Checklist](./checklist_container.md) | Deploying a new container |

### Distro Notes

| Document | Distribution |
|---|---|
| [Debian](./distros/notes_debian.md) | Debian — setup, GNOME, common packages |
| [Alpine](./distros/notes_alpine.md) | Alpine Linux — apk, services, minimal setup |
| [Ubuntu](./distros/notes_ubuntu.md) | Ubuntu — snap, Netplan, cloud-init, LTS |
| [Rocky Linux](./distros/notes_rocky.md) | Rocky Linux / RHEL — dnf, SELinux, firewalld |
| [Arch Linux](./distros/notes_arch.md) | Arch Linux — pacman, AUR, rolling release |

### Software Catalogs

| Document | Description |
|---|---|
| [Nice Software](./softwares/nice_software.md) | Useful utilities and everyday tools |
| [Security Tools](./softwares/security_tools.md) | Security testing and penetration testing tools |
| [SMTP Tools](./softwares/smtp_tools.md) | Email and SMTP testing tools |

### Installation Guides

| Document | Description |
|---|---|
| [Google Drive (ocamlfuse)](./installation-instructions/ocalm-fuse.md) | Mounting Google Drive on Linux via FUSE |

---

## Contributing

Contributions are welcome. Open a pull request with additions, corrections, or new sections. Keep entries concise and practical — this is a reference, not a tutorial.

Licensed under [Apache 2.0](./LICENSE).
