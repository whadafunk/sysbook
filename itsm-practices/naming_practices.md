# Network naming conventions

#### **A couple of rules for naming our network and infrastructure equipment**

### We are proposing the following categories of encodings:

- **location** *ex: f30, nx, dr*
- **capabilities**
    - router - *rt*
    - switch - *sw*
    - firewall - *fw*
    - access point - *ap*
    - IP Phone - *po*
    - Reverse Proxy / ADC - *rp*
    - Proxy - *px*
    - RADIUS / Authentication Server - *at*

- **aggregate** - 0 

- **vendor**
    - cisco  - *cs*
    - juniper - *jn*
    - forti - *ft*
    - checkpoint - *ck*
    - microsoft - *ms*

- **layer/function**
    - access - *acc*
    - core - *cor*
    - distribution - *dst*
    - user - *usr*
    - server - *srv*
    - internet router - *int*
    - wan router - *wan*
    - edge router - *edg*
    

### Using the above encodings we can think of some naming structures for our equipment depending on equipment type

- **Switch Naming** -> **L**ocation-**C**apabilities**A**ggregation**L**ayer-**V**endor**N**umber**F**loor

#### Examples:

**f30-swrt0cor-cs** - *a switch aggregate with routing capabilities in f30 location, that functions on the core layer, and is from cisco vendor*
**f30-sw0acc-jn01e1** - *the first switch aggregate in f30 location, that functions as an access switch at first floor, from juniper vendor*
**nx-swusr-cs02e3**   - *a non-aggregate switch, from cisco, with number 2 on the 3rd floor in nx location, that functions as user access*
**nx-swsrv-cs02e3**   - *a non-aggregate switch, from cisco, with number 2 on the 3rd floor in nx location, that functions as server access*

***The vendor does not seem like a very important info, and we can drop it***

**f30-swrt0cor**
**f30-sw0acc-01e1**
**nx-swusr-02e3**

***Let's see also some other types of equipment***

**f30-fw0cor** - *the aggregate firewall core in f30 location*
**f30-fwcor01** - *the first member of the firewall core aggregate*
**f30-fw0lsd** - *the aggregate firewall for livesd in f30 location*
**nx-fw0its** - *the aggregate firewall for internet services*




### Other naming component to be used in fqdns or something else

- dns - ns
- ntp - tm
- dhcp - ip
- dc - dc
- mail - mx



### Naming conventions and encodings for Networks:


#### Network Types:


- **LAN** - internal network (users or services)
- **DMZ** - services exposed to internet
- **USR** - internal users network
- **SRV** - internal services network
- **MGMT** - internal management network
- **VPN** - remote vpn network
- **TUN** - vpn site remote network
- **WAN** - generic remote network (IPSec, IPVPN, PPP, etc)
- **XCN** - interconnect
- **WFI** - wifi network
- **iNET** - internet public ip subnet
- **OOB** - generic out of band network (ilo, management, etc)
- **ILO** - ilo network

Network naming can have the following structure:

**L**ocation-**T**ype-**O**wner-**N**umber

#### Network naming examples:


- F30-SRV-1
- NX-USR-Admin
- NX-USR-Guest
- NX-USR-WiFi
- F30-SRV-BitHat
- F30-SRV-Sandbox
- F30-DMZ-Asee
- F30-MGMT-VMWare
- F30-OOB-VMotion
- F30-OOB-Backup
- F30-XCN-FW1.FW2


#### Network color convention proposal:


- **USR** - White
- **SRV** - Green
- **DMZ** - Orange
- **iNET** - Red
- **OOB** / **MGMT** - Blue
- **VPN** - Violet
- **TUN** / **WAN** - Yellow
- **XCN** - Brown
