# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Runit service scripts from the Void Linux project"
HOMEPAGE="https://voidlinux.org/"
SRC_URI="https://github.com/void-linux/void-packages/archive/master.tar.gz -> void-packages-master.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
S="${WORKDIR}/void-packages-master/srcpkgs"

IUSE="
	3proxy acpi alertmanager alfred alsa android anope apache armagetronad
	arptables at atop audit autofs avahi bacula barrier beanstalkd bind bird
	bitlbee blackbox_exporter bluetooth bluetooth-alsa boinc bolt brltty bumblebee
	burp busybox cachefilesd caddy canto-daemon cgmanager cgminer cgroups
	chronograf chrony ckb clockspeed cntlm collectd connman consolekit containerd
	coturn couchdb criu cronie cups darkhttpd dbus dcron ddclient deluge dhcp
	dhcpcd dictd diod distcc dkimproxy dnscrypt-proxy dnsmasq docker dovecot
	drbd-utils dropbear earlyoom ebtables edac-utils elasticsearch espeakup etcd
	eternalterminal fail2ban fastd fcron fiche flannel freeipmi frp frr fwknop gdm
	geomyidae gerbera gitea gitlab-runner glusterfs gogs gpm gpsd grafana h2o
	haproxy haveged hddtemp hiawatha hitch hostapd hyperion i2pd i8kutils icinga2
	iio-sensor-proxy incron influxdb inspircd iptables ipvsadm irqbalance iwd
	jenkins kapacitor kea keepalived kerberos kubernetes laptop libratbag libvirt
	lightdm lighttpd lm_sensors lsyncd lvm lxc lxcfs lxd lxdm mariadb mbpfan mcelog
	mdadm metalog minidlna minio monero monit monkeyd moosefs mopidy mpd
	mpdscribble munge musl-nscd mysql nbd netdata networkmanager nfs nftables nginx
	ngircd nix node_exporter nrpe nsd nss-pam-ldapd ntp nullmailer nut ofono
	oidentd olsrd openldap openntpd opensmtpd openssh openvswitch orientdb
	pcsc-lite php policykit polipo popcorn postfix postgresql preload privoxy
	prometheus prosody pulseaudio puppet qemu-guest-agent quassel radeon radicale
	radius radvd redis rest-server rkt rmilter rng-tools rpcbind rspamd rsync
	rsyslog rtkit salt samba sddm shadowsocks-libev shorewall slim smartmontools
	snapper sndio spamassassin spampd spice-vdagent spreed-webrtc squid sshguard
	sslh sssd strongswan subversion suricata syncthing synergy taskd telegraf
	thermald thinkfan thttpd tinc tinyproxy tinyssh tlp tlsdate tomcat tor
	transmission trousers tuntox twoftpd udev ufw ulogd umurmur unbound uptimed
	usbip usbmuxd uuid vault virtualbox vmware vnstat vsftpd watchdog wesnoth wicd
	wpa_actiond wpa_supplicant xdm xen xinetd xl2tpd zabbix zerotier znc zookeeper
"
REQUIRED_USE="|| ( ${IUSE} )"
RDEPEND="
	sys-process/runit
	3proxy? ( net-proxy/3proxy )
	acpi? ( sys-power/acpid )
	alertmanager? ( app-metrics/alertmanager )
	alfred? ( net-misc/alfred )
	alsa? ( media-sound/alsa-utils )
	android? ( dev-util/android-tools )
	anope? ( net-irc/anope )
	apache? ( www-servers/apache )
	armagetronad? ( games-action/armagetronad )
	arptables? ( net-firewall/arptables )
	at? ( sys-process/at )
	atop? ( sys-process/atop )
	audit? ( sys-process/audit )
	autofs? ( net-fs/autofs )
	avahi? ( net-dns/avahi )
	bacula? ( app-backup/bacula )
	barrier? ( x11-misc/barrier )
	beanstalkd? ( app-misc/beanstalkd )
	bind? ( net-dns/bind )
	bird? ( net-misc/bird )
	bitlbee? ( net-im/bitlbee )
	blackbox_exporter? ( app-metrics/blackbox_exporter )
	bluetooth? ( net-wireless/bluez )
	bluetooth-alsa? ( media-sound/bluez-alsa )
	boinc? ( sci-misc/boinc )
	bolt? ( dev-ml/bolt )
	brltty? ( app-accessibility/brltty )
	bumblebee? ( x11-misc/bumblebee )
	burp? ( app-backup/burp )
	busybox? ( sys-apps/busybox )
	cachefilesd? ( sys-fs/cachefilesd )
	caddy? ( www-servers/caddy )
	canto-daemon? ( net-news/canto-daemon )
	cgmanager? ( app-admin/cgmanager )
	cgminer? ( net-misc/cgminer )
	cgroups? ( dev-libs/libcgroup )
	chronograf? ( net-analyzer/chronograf )
	chrony? ( net-misc/chrony )
	ckb? ( app-misc/ckb )
	clockspeed? ( net-misc/clockspeed )
	cntlm? ( net-proxy/cntlm )
	collectd? ( app-metrics/collectd )
	connman? ( net-misc/connman )
	consolekit? ( sys-auth/consolekit )
	containerd? ( app-emulation/containerd )
	coturn? ( net-im/coturn )
	couchdb? ( dev-db/couchdb )
	criu? ( sys-process/criu )
	cronie? ( sys-process/cronie )
	cups? ( net-print/cups )
	darkhttpd? ( www-servers/darkhttpd )
	dbus? ( dev-haskell/dbus )
	dcron? ( sys-process/dcron )
	ddclient? ( net-dns/ddclient )
	deluge? ( net-p2p/deluge )
	dhcp? ( net-misc/dhcp )
	dhcpcd? ( net-misc/dhcpcd )
	dictd? ( app-text/dictd )
	diod? ( net-fs/diod )
	distcc? ( sys-devel/distcc )
	dkimproxy? ( mail-filter/dkimproxy )
	dnscrypt-proxy? ( net-dns/dnscrypt-proxy )
	dnsmasq? ( net-dns/dnsmasq )
	docker? ( app-emulation/docker )
	dovecot? ( net-mail/dovecot )
	drbd-utils? ( sys-cluster/drbd-utils )
	dropbear? ( net-misc/dropbear )
	earlyoom? ( sys-apps/earlyoom )
	ebtables? ( net-firewall/ebtables )
	edac-utils? ( sys-apps/edac-utils )
	elasticsearch? ( app-misc/elasticsearch )
	espeakup? ( app-accessibility/espeakup )
	etcd? ( dev-db/etcd )
	eternalterminal? ( app-shells/eternalterminal )
	fail2ban? ( net-analyzer/fail2ban )
	fastd? ( net-misc/fastd )
	fcron? ( sys-process/fcron )
	fiche? ( net-misc/fiche )
	flannel? ( app-emulation/flannel )
	freeipmi? ( sys-libs/freeipmi )
	frp? ( net-proxy/frp-bin )
	frr? ( net-misc/frr )
	fwknop? ( net-firewall/fwknop )
	gdm? ( gnome-base/gdm )
	geomyidae? ( net-misc/geomyidae )
	gerbera? ( net-misc/gerbera )
	gitea? ( www-apps/gitea )
	gitlab-runner? ( dev-util/gitlab-runner )
	glusterfs? ( sys-cluster/glusterfs )
	gogs? ( www-apps/gogs )
	gpm? ( sys-libs/gpm )
	gpsd? ( sci-geosciences/gpsd )
	grafana? ( www-apps/grafana )
	h2o? ( www-servers/h2o )
	haproxy? ( net-proxy/haproxy )
	haveged? ( sys-apps/haveged )
	hddtemp? ( app-admin/hddtemp )
	hiawatha? ( www-servers/hiawatha )
	hitch? ( net-proxy/hitch )
	hostapd? ( net-wireless/hostapd )
	hyperion? ( media-plugins/hyperion )
	i2pd? ( net-vpn/i2pd )
	i8kutils? ( app-laptop/i8kutils )
	icinga2? ( net-analyzer/icinga2 )
	iio-sensor-proxy? ( app-misc/iio-sensor-proxy )
	incron? ( sys-process/incron )
	influxdb? ( dev-db/influxdb )
	inspircd? ( net-irc/inspircd )
	iptables? ( net-firewall/iptables )
	ipvsadm? ( sys-cluster/ipvsadm )
	irqbalance? ( sys-apps/irqbalance )
	iwd? ( net-wireless/iwd )
	jenkins? ( dev-util/jenkins-bin )
	kapacitor? ( net-analyzer/kapacitor )
	kea? ( net-misc/kea )
	keepalived? ( sys-cluster/keepalived )
	kerberos? ( app-crypt/mit-krb5 )
	kubernetes? (
		sys-cluster/kube-apiserver
		sys-cluster/kube-controller-manager
		sys-cluster/kube-proxy
		sys-cluster/kube-scheduler
		sys-cluster/kubelet )
	laptop? ( app-laptop/laptop-mode-tools )
	libratbag? ( dev-libs/libratbag )
	libvirt? ( app-emulation/libvirt )
	lightdm? ( x11-misc/lightdm )
	lighttpd? ( www-servers/lighttpd )
	lm_sensors? ( sys-apps/lm_sensors )
	lsyncd? ( app-admin/lsyncd )
	lvm? ( sys-fs/lvm2 )
	lxc? ( app-emulation/lxc )
	lxcfs? ( sys-fs/lxcfs )
	lxd? ( app-emulation/lxd )
	lxdm? ( lxde-base/lxdm )
	mariadb? ( dev-db/mariadb )
	mbpfan? ( app-laptop/mbpfan )
	mcelog? ( app-admin/mcelog )
	mdadm? ( sys-fs/mdadm )
	metalog? ( app-admin/metalog )
	minidlna? ( net-misc/minidlna )
	minio? ( net-fs/minio )
	monero? ( net-p2p/monero )
	monit? ( app-admin/monit )
	monkeyd? ( www-servers/monkeyd )
	moosefs? ( sys-cluster/moosefs )
	mopidy? ( media-sound/mopidy )
	mpd? ( media-sound/mpd )
	mpdscribble? ( media-sound/mpdscribble )
	munge? ( sys-auth/munge )
	musl-nscd? ( sys-libs/musl-nscd )
	mysql? ( dev-db/mysql )
	nbd? ( sys-block/nbd )
	netdata? ( net-analyzer/netdata )
	networkmanager? ( net-misc/networkmanager )
	nfs? ( net-fs/nfs-utils )
	nftables? ( net-firewall/nftables )
	nginx? ( www-servers/nginx )
	ngircd? ( net-irc/ngircd )
	nix? ( sys-apps/nix )
	node_exporter? ( app-metrics/node_exporter )
	nrpe? ( net-analyzer/nrpe )
	nsd? ( net-dns/nsd )
	nss-pam-ldapd? ( sys-auth/nss-pam-ldapd )
	ntp? ( net-misc/ntp )
	nullmailer? ( mail-mta/nullmailer )
	nut? ( app-misc/nut )
	ofono? ( net-misc/ofono )
	oidentd? ( net-misc/oidentd )
	olsrd? ( net-misc/olsrd )
	openldap? ( net-nds/openldap )
	openntpd? ( net-misc/openntpd )
	opensmtpd? ( mail-mta/opensmtpd )
	openssh? ( net-misc/openssh )
	openvswitch? ( net-misc/openvswitch )
	orientdb? ( dev-db/orientdb-bin )
	pcsc-lite? ( sys-apps/pcsc-lite )
	php? ( dev-lang/php )
	policykit? ( sys-auth/polkit )
	polipo? ( net-proxy/polipo )
	popcorn? ( media-tv/popcorntime-bin )
	postfix? ( mail-mta/postfix )
	postgresql? ( dev-db/postgresql )
	preload? ( sys-apps/preload )
	privoxy? ( net-proxy/privoxy )
	prometheus? ( app-metrics/prometheus )
	prosody? ( net-im/prosody )
	pulseaudio? ( media-sound/pulseaudio )
	puppet? ( app-admin/puppet )
	qemu-guest-agent? ( app-emulation/qemu-guest-agent )
	quassel? ( net-irc/quassel )
	radeon? ( x11-apps/radeon-profile-daemon )
	radicale? ( www-apps/radicale )
	radius? ( dev-ruby/radius )
	radvd? ( net-misc/radvd )
	redis? ( dev-db/redis )
	rest-server? ( www-servers/rest-server )
	rkt? ( app-emulation/rkt )
	rmilter? ( mail-filter/rmilter )
	rng-tools? ( sys-apps/rng-tools )
	rpcbind? ( net-nds/rpcbind )
	rspamd? ( mail-filter/rspamd )
	rsync? ( net-misc/rsync )
	rsyslog? ( app-admin/rsyslog )
	rtkit? ( sys-auth/rtkit )
	salt? ( app-admin/salt )
	samba? ( net-fs/samba )
	sddm? ( x11-misc/sddm )
	shadowsocks-libev? ( net-proxy/shadowsocks-libev )
	shorewall? ( net-firewall/shorewall )
	slim? ( dev-ruby/slim )
	smartmontools? ( sys-apps/smartmontools )
	snapper? ( app-backup/snapper )
	sndio? ( media-sound/sndio )
	spamassassin? ( mail-filter/spamassassin )
	spampd? ( mail-filter/spampd )
	spice-vdagent? ( app-emulation/spice-vdagent )
	spreed-webrtc? ( www-servers/spreed-webrtc )
	squid? ( net-proxy/squid )
	sshguard? ( app-admin/sshguard )
	sslh? ( net-misc/sslh )
	sssd? ( sys-auth/sssd )
	strongswan? ( net-vpn/strongswan )
	subversion? ( dev-vcs/subversion )
	suricata? ( net-analyzer/suricata )
	syncthing? ( net-p2p/syncthing )
	synergy? ( x11-misc/synergy )
	taskd? ( app-misc/taskd )
	telegraf? ( net-analyzer/telegraf )
	thermald? ( sys-power/thermald )
	thinkfan? ( app-laptop/thinkfan )
	thttpd? ( www-servers/thttpd )
	tinc? ( net-vpn/tinc )
	tinyproxy? ( net-proxy/tinyproxy )
	tinyssh? ( net-misc/tinyssh )
	tlp? ( app-laptop/tlp )
	tlsdate? ( net-misc/tlsdate )
	tomcat? ( www-servers/tomcat )
	tor? ( net-vpn/tor )
	transmission? ( net-p2p/transmission )
	trousers? ( app-crypt/trousers )
	tuntox? ( net-vpn/tuntox )
	twoftpd? ( net-ftp/twoftpd )
	udev? ( sys-fs/udev )
	ufw? ( net-firewall/ufw )
	ulogd? ( app-admin/ulogd )
	umurmur? ( media-sound/umurmur )
	unbound? ( net-dns/unbound )
	uptimed? ( app-misc/uptimed )
	usbip? ( net-misc/usbip )
	usbmuxd? ( app-pda/usbmuxd )
	uuid? ( dev-go/uuid )
	vault? ( app-admin/vault )
	virtualbox? ( app-emulation/virtualbox )
	vmware? ( app-emulation/open-vm-tools )
	vnstat? ( net-analyzer/vnstat )
	vsftpd? ( net-ftp/vsftpd )
	watchdog? ( dev-python/watchdog )
	wesnoth? ( games-strategy/wesnoth )
	wicd? ( net-misc/wicd )
	wpa_actiond? ( net-wireless/wpa_actiond )
	wpa_supplicant? ( net-wireless/wpa_supplicant )
	xdm? ( x11-apps/xdm )
	xen? ( app-emulation/xen )
	xinetd? ( sys-apps/xinetd )
	xl2tpd? ( net-dialup/xl2tpd )
	zabbix? ( net-analyzer/zabbix )
	zerotier? ( net-misc/zerotier )
	znc? ( net-irc/znc )
	zookeeper? ( sys-cluster/zookeeper )
"

src_install() {
	files="3proxy 3proxy/files/3proxy
acpi acpid/files/acpid
alertmanager alertmanager/files/alertmanager
alfred alfred/files/alfred
alfred alfred/files/batadv-vis
alsa alsa-utils/files/alsa
android android-tools/files/adb
anope anope/files/anope
apache apache/files/apache
armagetronad armagetronad/files/armagetronad-dedicated
arptables arptables/files/arptables
at at/files/at
atop atop/files/atop
audit audit/files/auditctl
audit audit/files/auditd
autofs autofs/files/autofs
avahi avahi/files/avahi-daemon
bacula bacula-common/files/bacula-dir
bacula bacula-common/files/bacula-fd
bacula bacula-common/files/bacula-sd
barrier barrier/files/barrierc
barrier barrier/files/barriers
beanstalkd beanstalkd/files/beanstalkd
bind bind/files/named
bird bird/files/bird
bitlbee bitlbee/files/bitlbee
blackbox_exporter blackbox_exporter/files/blackbox_exporter
bluetooth bluez-alsa/files/bluez-alsa
bluetooth bluez/files/bluetoothd
boinc boinc/files/boinc
bolt bolt/files/boltd
brltty brltty/files/brltty
bumblebee bumblebee/files/bumblebeed
burp burp-server/files/burp-server
busybox busybox/files/busybox-klogd
busybox busybox/files/busybox-ntpd
busybox busybox/files/busybox-syslogd
cachefilesd cachefilesd/files/cachefilesd
caddy caddy/files/caddy
canto-daemon canto-next/files/canto-daemon
cgmanager cgmanager/files/cgmanager
cgminer cgminer/files/cgminer
cgroups libcgroup/files/cgred
chronograf chronograf/files/chronograf
chrony chrony/files/chronyd
ckb ckb-next/files/ckb-next-daemon
clockspeed clockspeed/files/clockspeed
clockspeed clockspeed/files/clockspeed_adjust
clockspeed clockspeed/files/taiclockd
cntlm cntlm/files/cntlm
collectd collectd/files/collectd
connman connman/files/connmand
consolekit ConsoleKit2/files/consolekit
containerd containerd/files/containerd
coturn coturn/files/coturnserver
couchdb couchdb/files/couchdb
criu criu/files/criu
cronie cronie/files/cronie
cups cups/files/cupsd
cups cups-filters/files/cups-browsed
darkhttpd darkhttpd/files/darkhttpd
dbus dbus/files/dbus
dcron dcron/files/dcron
ddclient ddclient/files/ddclient
deluge deluge/files/deluged
deluge deluge/files/deluge-web
dhcpcd dhcpcd/files/dhcpcd
dhcpcd dhcpcd/files/dhcpcd-eth0
dhcp dhcp/files/dhclient
dhcp dhcp/files/dhcpd4
dhcp dhcp/files/dhcpd6
dictd dictd/files/dictd
diod diod/files/diod
distcc distcc/files/distccd
dkimproxy dkimproxy/files/dkimproxy_in
dkimproxy dkimproxy/files/dkimproxy_out
dnscrypt-proxy dnscrypt-proxy/files/dnscrypt-proxy
dnsmasq dnsmasq/files/dnsmasq
docker docker/files/docker
dovecot dovecot/files/dovecot
drbd-utils drbd-utils/files/drbd
dropbear dropbear/files/dropbear
earlyoom earlyoom/files/earlyoom
ebtables ebtables/files/ebtables
edac-utils edac-utils/files/edac
elasticsearch elasticsearch/files/elasticsearch
espeakup espeakup/files/espeakup
etcd etcd/files/etcd
eternalterminal EternalTerminal/files/etserver
fail2ban fail2ban/files/fail2ban
fastd fastd/files/fastd
fcron fcron/files/fcron
fiche fiche/files/fiche
flannel flannel/files/flannel
freeipmi freeipmi/files/bmc-watchdog
freeipmi freeipmi/files/ipmidetectd
freeipmi freeipmi/files/ipmiseld
frp frp/files/frpc
frp frp/files/frps
frr frr/files/babeld
frr frr/files/bfdd
frr frr/files/bgpd
frr frr/files/eigrpd
frr frr/files/fabricd
frr frr/files/frr-generic
frr frr/files/isisd
frr frr/files/ldpd
frr frr/files/nhrpd
frr frr/files/ospf6d
frr frr/files/ospfd
frr frr/files/pbrd
frr frr/files/pimd
frr frr/files/ripd
frr frr/files/ripngd
frr frr/files/sharpd
frr frr/files/staticd
frr frr/files/zebra
fwknop fwknop/files/fwknopd
gdm gdm/files/gdm
geomyidae geomyidae/files/geomyidae
gerbera gerbera/files/gerbera
gitea gitea/files/gitea
gitlab-runner gitlab-runner/files/gitlab-runner
glusterfs glusterfs/files/glusterd
glusterfs glusterfs/files/glusterfsd
gogs gogs/files/gogs
gpm gpm/files/gpm
gpsd gpsd/files/gpsd
grafana grafana/files/grafana
h2o h2o/files/h2o
haproxy haproxy/files/haproxy
haveged haveged/files/haveged
hddtemp hddtemp/files/hddtemp
hiawatha hiawatha/files/hiawatha
hitch hitch/files/hitch
hostapd hostapd/files/hostapd
hyperion hyperion/files/hyperiond
i2pd i2pd/files/i2pd
i8kutils i8kutils/files/i8kmon
icinga2 icinga2/files/icinga2
iio-sensor-proxy iio-sensor-proxy/files/iio-sensor-proxy
incron incron/files/incron
influxdb influxdb/files/influxdb
inspircd inspircd/files/inspircd
iptables iptables/files/ip6tables
iptables iptables/files/iptables
ipvsadm ipvsadm/files/ipvsadm
irqbalance irqbalance/files/irqbalance
iwd iwd/files/iwd
jenkins jenkins/files/jenkins
kapacitor kapacitor/files/kapacitor
kea kea/files/kea-dhcp4
kea kea/files/kea-dhcp6
kea kea/files/kea-dhcp-ddns
keepalived keepalived/files/keepalived
kerberos mit-krb5/files/kadmind
kerberos mit-krb5/files/krb5kdc
kubernetes kubernetes/files/kube-apiserver
kubernetes kubernetes/files/kube-controller-manager
kubernetes kubernetes/files/kubelet
kubernetes kubernetes/files/kube-proxy
kubernetes kubernetes/files/kube-scheduler
laptop laptop-mode/files/laptop-mode
libratbag libratbag/files/ratbagd
libvirt libvirt/files/libvirtd
libvirt libvirt/files/virtlockd
libvirt libvirt/files/virtlogd
lightdm lightdm/files/lightdm
lighttpd lighttpd/files/lighttpd
lm_sensors lm_sensors/files/fancontrol
lsyncd lsyncd/files/lsyncd
lvm lvm2/files/dmeventd
lvm lvm2/files/lvmetad
lxcfs lxcfs/files/lxcfs
lxc lxc/files/lxc-autostart
lxd lxd/files/lxd
lxdm lxdm/files/lxdm
mariadb mariadb/files/mysqld
mbpfan mbpfan/files/mbpfan
mcelog mcelog/files/mcelog
mdadm mdadm/files/mdadm
metalog metalog/files/metalog
minidlna minidlna/files/minidlnad
minio minio/files/minio
monero monero/files/monerod
monit monit/files/monit
monkeyd monkey/files/monkey
moosefs moosefs/files/mfschunkserver
moosefs moosefs/files/mfsmaster
moosefs moosefs/files/mfsmetalogger
mopidy mopidy/files/mopidy
mpd mpd/files/mpd
mpdscribble mpdscribble/files/mpdscribble
munge munge/files/munge
musl-nscd musl-nscd/files/nscd
mysql mysql/files/mysqld
nbd nbd/files/nbd
netdata netdata/files/netdata
networkmanager NetworkManager/files/NetworkManager
nfs nfs-utils/files/nfs-server
nfs nfs-utils/files/rpcblkmapd
nfs nfs-utils/files/rpcgssd
nfs nfs-utils/files/rpcidmapd
nfs nfs-utils/files/rpcsvcgssd
nfs nfs-utils/files/statd
nftables nftables/files/nftables
nginx nginx/files/nginx
ngircd ngircd/files/ngircd
nix nix/files/nix-daemon
node_exporter node_exporter/files/node_exporter
nrpe nrpe/files/nrpe
nsd nsd/files/nsd
nss-pam-ldapd nss-pam-ldapd/files/nslcd
ntp ntp/files/isc-ntpd
nullmailer nullmailer/files/nullmailer
nut network-ups-tools/files/upsd
nut network-ups-tools/files/upsdrvctl
nut network-ups-tools/files/upsmon
ofono ofono/files/ofonod
oidentd oidentd/files/oidentd
olsrd olsrd/files/olsrd
openldap openldap/files/slapd
openntpd openntpd/files/openntpd
opensmtpd opensmtpd/files/opensmtpd
openssh openssh/files/sshd
openvswitch openvswitch/files/ovsdb-server
openvswitch openvswitch/files/ovs-vswitchd
orientdb orientdb/files/orientdb
pcsc-lite pcsclite/files/pcscd
php php/files/php-fpm
policykit polkit/files/polkitd
polipo polipo/files/polipo
popcorn PopCorn/files/popcorn
popcorn PopCorn/files/pqueryd
popcorn PopCorn/files/statrepo
postfix postfix/files/postfix
postgresql postgresql/files/postgresql
preload preload/files/preload
privoxy privoxy/files/privoxy
prometheus prometheus/files/prometheus
prosody prosody/files/prosody
pulseaudio pulseaudio/files/pulseaudio
puppet puppet/files/puppet
puppet puppet/files/puppetmaster
qemu-guest-agent qemu/files/qemu-ga
quassel quassel/files/quasselcore
radeon radeon-profile-daemon/files/radeon-profile-daemon
radicale radicale/files/radicale
radius FreeRADIUS/files/FreeRADIUS
radvd radvd/files/radvd
redis redis/files/redis
rest-server rest-server/files/rest-server
rkt rkt/files/rkt-metadata
rmilter rmilter/files/rmilter
rng-tools rng-tools/files/rngd
rpcbind rpcbind/files/rpcbind
rspamd rspamd/files/rspamd
rsync rsync/files/rsyncd
rsyslog rsyslog/files/rsyslogd
rtkit rtkit/files/rtkit
salt salt/files/salt-api
salt salt/files/salt-master
salt salt/files/salt-minion
salt salt/files/salt-syndic
samba samba/files/nmbd
samba samba/files/smbd
sddm sddm/files/sddm
shadowsocks-libev shadowsocks-libev/files/shadowsocks-libev-client
shadowsocks-libev shadowsocks-libev/files/shadowsocks-libev-server
shorewall shorewall/files/shorewall
shorewall shorewall/files/shorewall6
slim slim/files/slim
smartmontools smartmontools/files/smartd
snapper snapper/files/snapperd
sndio sndio/files/sndiod
spamassassin spamassassin/files/spamd
spampd spampd/files/spampd
spice-vdagent spice-vdagent/files/spice-vdagentd
spreed-webrtc spreed-webrtc/files/spreed-webrtc-server
squid squid/files/squid
sshguard sshguard/files/sshguard-socklog
sslh sslh/files/sslh
sssd sssd/files/sssd
strongswan strongswan/files/strongswan
subversion subversion/files/svnserve
suricata suricata/files/suricata
syncthing syncthing/files/relaysrv
synergy synergy/files/synergyc
synergy synergy/files/synergys
taskd taskd/files/taskd
telegraf telegraf/files/telegraf
thermald thermald/files/thermald
thinkfan thinkfan/files/thinkfan
thttpd thttpd/files/thttpd
tinc tinc/files/tincd
tinyproxy tinyproxy/files/tinyproxy
tinyssh tinyssh/files/tinysshd
tlp tlp/files/tlp
tlsdate tlsdate/files/tlsdated
tomcat apache-tomcat/files/apache-tomcat
tor tor/files/tor
transmission transmission/files/transmission-daemon
trousers trousers/files/tcsd
tuntox tuntox/files/tuntox
twoftpd twoftpd/files/twoftpd-anon
udev eudev/files/udevd
ufw ufw/files/ufw
ulogd ulogd/files/ulogd
umurmur umurmur/files/umurmurd
unbound unbound/files/unbound
uptimed uptimed/files/uptimed
usbip linux-tools/files/usbipd
usbmuxd usbmuxd/files/usbmuxd
uuid util-linux/files/uuidd
vault vault/files/vault
virtualbox virtualbox-ose/files/vboxservice
virtualbox virtualbox-ose/files/vboxwebsrv
vmware open-vm-tools/files/vmtoolsd
vnstat vnstat/files/vnstatd
vsftpd vsftpd/files/vsftpd
vsftpd vsftpd/files/vsftpd-ipv6
watchdog watchdog/files/watchdog
wesnoth wesnoth/files/wesnothd
wicd wicd/files/wicd
wpa_actiond wpa_actiond/files/wpa_actiond
wpa_supplicant wpa_supplicant/files/wpa_supplicant
xdm xdm/files/xdm
xen xen/files/xen
xen xen/files/xenconsoled
xen xen/files/xenstored
xinetd xinetd/files/xinetd
xl2tpd xl2tpd/files/xl2tpd
zabbix zabbix/files/zabbix-agent
zabbix zabbix/files/zabbix-proxy
zabbix zabbix/files/zabbix-server
zerotier zerotier-one/files/zerotier
znc znc/files/znc
zookeeper zookeeper/files/zookeeper"

	printf '%s' "${files}" | while IFS=' ' read -r use dir; do
		if use "${use}"; then
			srv="$(basename "${dir}")"
			insinto "/etc/runit/sv"
			doins -r "${dir}"
			fperms 0755 "/etc/runit/sv/${srv}/run"
			if [ -r "${dir}/check" ]; then
				fperms 0755 "/etc/runit/sv/${srv}/check"
			fi
			if [ -r "${dir}/finish" ]; then
				fperms 0755 "/etc/runit/sv/${srv}/finish"
			fi
			if [ -d "${dir}/log" ]; then
				fperms 0755 "/etc/runit/sv/${srv}/log/run"
			fi
                        for file in $(find "${dir}" -name '*.sh'); do
				name="$(basename "${file}")"
				fperms 0755 "/etc/runit/sv/${srv}/${name}"
			done
		fi
	done
}
