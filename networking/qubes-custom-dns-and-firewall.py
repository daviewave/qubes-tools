import os, sys, subprocess


from dbus import SystemBus
from dbus.exceptions import DBusException
from ipaddress import IPv4Address


# a)
# [get_dns_resolvers()]-> use system dbus to get resolvers
# [get_dns_nameservers()]-> use resolvers to get nameservers
#   if:
#     [handle_custom()]-> if custom, requires extra step to convert to usable ip
#     [handle_standard()]-> if regular, addresses stored in plain text in /etc/resolv.conf


# helpers
def handle_dbus_exception(exception):
    NON_CRITICAL_ERRORS = [
        "org.freedesktop.systemd1."  #
        "org.freedesktop.DBus.Error.NoReply",
        "org.freedesktop.DBus.Error.ServiceUnknown",
        "org.freedesktop.DBus.Error.NameHasNoOwner",
        "org.freedesktop.DBus.Error.NoSuchUnit",
    ]
    # key:
    #   -1: non critical, can still try to use default dns
    #   1: script ender but gracefully, return to function and raise exception there to get better traceback
    #   2(doesnt really matter the value): triggered an exception in error handling, raise here

    try:
        error = exception.get_dbus_name()
        if error in NON_CRITICAL_ERRORS:
            print(f"warning! non-critical error occurred: {error}")
            return 0
        else:
            print(f"warning! critical error occurred: {error}")
            return 1
    except DBusException as e:
        print(f"error! something went really wrong! {error}")
        raise DBusException(e)


# -- 1.b,
def convert_nameservers_to_resolvers(nameservers):
    resolver_addrs = []
    if type(nameservers[0]) == str:
        # normal from /etc/resolv.conf
        resolver_addrs = [ns.split(" ")[1] for ns in nameservers]
        return resolver_addrs
    else:
        # recieved custom in byte format
        for ns in nameservers:
            for ifindex, family, addr in ns:
                resolver_addrs.append(IPv4Address(bytes(addr)))
    return resolver_addrs


# -- 1.a,
def get_dns_nameservers():
    # i, custom
    nameservers = []
    try:
        sys_dbus = SystemBus()
        resolve1 = sys_dbus.get_object(
            "org.freedesktop.resolv1", "/org/freedesktop/resolve1"
        )
        resolve2 = sys_dbus.get_object(
            "org.freedesktop.resolv2", "/org/freedesktop/resolve2"
        )
        nameservers = [resolve1, resolve2]
    except DBusException as e:
        error_code = handle_dbus_exception(e)
        if error_code == 1:
            raise DBusException(e)

    # ii, normal -- we can assume nameservers list is empty if reaches here
    try:
        with open("/etc/resolv.conf", "r") as f:
            config_contents = f.readlines()
            f.close()
            nameservers = config_contents
    except DBusException as e:
        print(
            "error! failed to attempted and failed to retrieve both the custom and standard dns nameservers"
        )
        raise DBusException(e)

    return nameservers


# == 1,
def get_dns_nameservers():
    # a,
    nameservers = get_dns_nameservers()

    # b,
    resolver_addrs = convert_nameservers_to_resolvers(nameservers)

    return resolver_addrs


# == 2,
def create_default_qubes_firewall():
    pass


def main():
    # 1, get dns nameservers (either custom or normal)
    dns_resolvers = get_dns_nameservers()

    # 2, use dns resolver addresses to construct the qubes default fw

    pass
