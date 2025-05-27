from __future__ import annotations
from typing import List

import os, sys, subprocess


from ipaddress import IPv4Address

import dbus
from dbus import SystemBus
from dbus.exceptions import DBusException


#-->(1,b) get backup nameservers from standard/default /etc/resolv.conf
def get_dns_resolv_conf():
	#i, get the nameservers defined in /etc/resolv.conf
    try:
		with open("/etc/resolv.conf", "r", encoding="UTF-8") as f:
        	nameservers = f.readlines()
			dns_resolvers = []
			for ns in nameservers:
				ip = ns.split(" ")[1]
				dns_resolvers.append(ip)
            f.close()
			return dns_resolvers


#-->(1,a) attempt to get custom (poisoned) dns ip addresses from freedesktop.org 
#	NOTE: unless using mdns on highly trusted network LAN, a known, trustworthy
#		dns provider should be chosen:
#			- google: 8.8.8.8 4.4.4.4
#			- quad9: 9.9.9.9 149.112.112.112
#			- cloudfare: 1.1.1.1 
def get_dns_resolved():
    pass
#     #->(i) use imported dbus package to get the system dbus name 
#     try:
#         bus = dbus.SystemBus() 
#     except dbus.exceptions.DBusException as s:
# 		sys_dbus = s.get_dbus_name()
# 		if sys_dbus == 'org.freedesktop.DBus.Error.NoReply':
# 			return get_dns_resolv_conf()
# 		raise DBusException(s)

# 	#->(ii) cant say for sure but if i had to guess this .get_object() method is fetching 
# 	#	the 'nameserver <ip>' from a remote freedesktop.org server
#     #		- NOTE: i think you are meaning to get 2 nameservers here, each resolver will
# 	#			return 1 dns nameserverwith each arg representing the nameserver to be
# 	#			fetched by the method call,
#     try:
#         resolve1 = bus.get_object('org.freedesktop.resolve1', '/org/freedesktop/resolve1')
# 		dns_nameserver1 = resolve1.Get('org.freedesktop.resolve1.Manager', 'DNS', dbus_interface='org.freedesktop.DBus.Properties')
# #       resolver2 = bus.get_object('org.freedesktop.resolve2', '/org/freedesktop/resolve2')
# #		dns_nameserver2 = resolve2.Get('org.freedesktop.resolve2.Manager', 'DNS', dbus_interface='org.freedesktop.DBus.Properties')
#     except dbus.exceptions.DBusException as s:
#     	error = s.get_dbus_name()
# 		non_critical_error_msgs = ['org.freedesktop.DBus.Error.ServiceUnknown', 'org.freedesktop.DBus.Error.NameHasNoOwner', 'org.freedesktop.DBus.Error.NoSuchUnit' ]
# 		if error in non_critical_error_msgs or error.startswith('org.freedesktop.systemd1.')
#             return get_dns_resolv_conf()
#         raise DBusException(s)

	# 3, use global entries first error occurs inst  
		#--> ps, ur only getting 1 at the moment aha
    # Only keep IPv4 entries. systemd-resolved is trusted to return valid addresses.
    # TODO: We only need abridged IPv4 DNS entries for ifindex == 0.
    # to ensure static DNS of disconnected network interfaces are not added.


	#->(iii)
	
		# for ifindex, family, addr in dns:
		# 		ipv4 = IPv4Address(bytes(addr)
		# 		return ipv4

#	dns.sort(key=lambda x: x[0] != 0)
#	return [IPv4Address(bytes(addr)) for ifindex, family, addr in dns
#       if family == 2]


#== QUBES DEFAULT FIREWALL ==#
def install_firewall_rules(dns):
    import qubesdb
    qdb = qubesdb.QubesDB()
    qubesdb_dns = []
    for i in ('/qubes-netvm-primary-dns', '/qubes-netvm-secondary-dns'):
        ns_maybe = qdb.read(i)
        if ns_maybe is None:
            continue
        try:
            qubesdb_dns.append(IPv4Address(ns_maybe.decode("ascii", "strict")))
        except (UnicodeDecodeError, ValueError):
            pass
    preamble = [
        'add table ip qubes',
        # Add the chain so that the subsequent delete will work. If the chain already
        # exists this is a harmless no-op.
        'add chain ip qubes dnat-dns',
        # Delete the chain so that if the chain already exists, it will be removed.
        # The removal of the old chain and addition of the new one happen as a single
        # atomic operation, so there is no period where neither chain is present or
        # where both are present.
        'delete chain ip qubes dnat-dns',
    ]
    rules = [
        'table ip qubes {',
        'chain dnat-dns {',
        'type nat hook prerouting priority dstnat; policy accept;',
    ]
    dns_resolved = get_dns_resolved()
    if not dns_resolved:
        # User has no IPv4 DNS set in sys-net. Maybe IPv6 only environment.
        # Or maybe user wants to enforce DNS-Over-HTTPS.
        # Drop IPv4 DNS requests to qubesdb_dns addresses.
        for vm_nameserver in qubesdb_dns:
            rules += [
                f"ip daddr {vm_nameserver} udp dport 53 drop",
                f"ip daddr {vm_nameserver} tcp dport 53 drop",
            ]
    else:
        while len(qubesdb_dns) > len(dns_resolved):
            # Ensure that upstream DNS pool is larger than qubesdb_dns pool
            dns_resolved = dns_resolved + dns_resolved
        for vm_nameserver, dest in zip(qubesdb_dns, dns_resolved):
            dns_ = str(dest)
            rules += [
                f"ip daddr {vm_nameserver} udp dport 53 dnat to {dns_}",
                f"ip daddr {vm_nameserver} tcp dport 53 dnat to {dns_}",
            ]
    rules += ["}", "}"]

    # check if new rules are the same as the old ones - if so, don't reload
    # and return that info via exit code
    try:
        old_rules = subprocess.check_output(
            ["nft", "list", "chain", "ip", "qubes", "dnat-dns"]).decode().splitlines()
    except subprocess.CalledProcessError:
        old_rules = []
    old_rules = [line.strip() for line in old_rules]

    if old_rules == rules:
        sys.exit(100)

    os.execvp("nft", ("nft", "--", "\n".join(preamble + rules)))

if __name__ == '__main__':
		#1, resolv ipv4 address using custom dns, falling back to default if 
		#			non-critical error occurs
		ipv4 = get_dns_resolved()

		#2, pass the resolved ipv4 address to the install firewall function as arg
    # install_firewall_rules(ipv4)
