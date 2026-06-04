# System Administration Practices

A set of non-negotiable habits for managing infrastructure professionally.

---

## SSH Key Authentication

Never use password-based SSH in production. Distribute SSH public keys to all managed hosts and disable `PasswordAuthentication` in `sshd_config`.

**Why:** Passwords are brute-forceable, often shared, and hard to audit. Key pairs are cryptographically strong, scoped per user, and easy to revoke.

**How:**
- Generate a keypair: `ssh-keygen -t ed25519 -C "user@host"`
- Distribute the public key: `ssh-copy-id user@host`
- In `/etc/ssh/sshd_config`:
  ```
  PasswordAuthentication no
  PubkeyAuthentication yes
  PermitRootLogin no
  ```
- Reload: `systemctl reload ssh`

---

## Host Summary Document

Every managed host must have a machine-readable summary at `/var/log/admin/host_summary`.  
Configure `sshd` to display it as MOTD on login (symlink `/etc/motd` to the file).

**Required fields:**

- Hostname (FQDN) and IP configuration (IP, netmask, gateway, DNS servers)
- Connected networks
- Active users and their authentication methods (password, SSH key, LDAP)
- Asset number, technical owner, business owner
- List of hosted services and their URIs
- Disk partitions and physical resources (CPU / memory / disk)
- Physical or virtual location (for VMs: hypervisor hostname and IP)
- Last change date

**Template:** See [`documentation_layout.md`](./documentation_layout.md) for a full infrastructure catalog template.

---

## Operational Journal

Every host must have an operational journal at `/var/log/admin/op_journal`.  
Log every non-trivial action taken on the machine — installs, config changes, incidents, reboots.

**Each entry must include:**

- Date and time of the operation
- Name(s) of the person(s) performing it
- Description of what was done
- Any important notes, side effects, or follow-up actions required

**Why:** A journal is the cheapest form of institutional memory. It answers "who did what and when" without digging through shell history or git logs. It also provides an audit trail for compliance and incident response.

---

## Machine Templates

Maintain a documented baseline for each class of machine (bare-metal server, VM, container). A template is a checklist of packages, services, configuration steps, and access controls that every new instance of that class must have before it is considered production-ready.

| Class | Template |
|---|---|
| Server | [checklist_server.md](../checklist_server.md) |
| Desktop | [checklist_desktop.md](../checklist_desktop.md) |
| Container | [checklist_container.md](../checklist_container.md) |

Templates reduce fleet inconsistency. When a template changes (e.g. a new tool is standardized), apply the delta to existing machines and log it in their operational journals.

---

## Documentation Standards

All infrastructure must be documented. Undocumented infrastructure is a liability — it cannot be safely handed over, audited, or recovered from failure.

**Minimum documentation per environment:**

- **Host inventory** — hostname, IP, OS, owner, purpose, asset number
- **Service catalog** — what service runs where, its URI, dependencies, and backup policy
- **Network map** — VLANs, tunnels, firewall zones; follow the schema in [`naming_practices.md`](./naming_practices.md)
- **Access matrix** — who has access to what and by what method (key, password, LDAP group)

See [`documentation_layout.md`](./documentation_layout.md) for a full documentation structure template.

---

## Change Management

No change to a production system should be undocumented or unplanned.

1. Log the intent in the operational journal **before** starting
2. Verify a rollback path exists
3. Perform the change during a maintenance window when possible
4. Update the host summary and any affected documentation after the change
5. Log the outcome in the operational journal, including any unexpected side effects

For significant changes (kernel upgrades, major package updates, network reconfigurations), test on a staging host first.

---

## Security Baseline

Every server must meet the following baseline before going into production:

- SSH key-only authentication, `PermitRootLogin no`
- Host-based firewall configured and enabled (iptables / nftables / ufw / firewalld)
- `fail2ban` installed and active for SSH at minimum
- File integrity monitoring (`tripwire` or equivalent) installed and initialized
- No unnecessary services running — audit with `systemctl list-units --type=service`
- No unnecessary open ports — audit with `ss -tlnp`
- Package list trimmed to only what is needed — audit with `apt-mark showmanual`
- CA certificates updated and trusted certificates reviewed
- Backup agent installed, configured, and reporting

---

## Backup and Asset Management

- Every production host must have a backup agent installed and actively reporting to a central backup server
- Every host must be registered in the asset management system (e.g. OCS Inventory)
- Backup schedules, retention policies, and restore procedures must be documented in the service catalog
- Backup restores must be tested periodically — an untested backup is not a backup
