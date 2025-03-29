#!/bin/bash

# Disable filesystems with limited use and frequent vulnerabilities
blacklist cramfs
blacklist freevxfs
blacklist jffs2
blacklist hfs
blacklist hfsplus
blacklist udf
#blacklist squashfs  # Live environments vulnerability

# Disable legacy or unused hardware interfaces
blacklist firewire-core  # FireWire (IEEE 1394)
blacklist firewire-sbp2  # FireWire storage
blacklist firewire-net   # FireWire networking
blacklist irda           # Infrared
blacklist sir_dev        # Serial infrared

# Disable USB mass storage (if not required)
#blacklist usb-storage
#blacklist uas  # Alternative USB SCSI

# Disable Bluetooth (if not required)
blacklist bluetooth
blacklist btusb

# Disable Direct Rendering Manager (DRM) modules
# gpu might need
#blacklist drm
#blacklist drm_kms_helper

# Disable rarely used networking protocols
blacklist dccp  # Datagram Congestion Control Protocol
blacklist sctp  # Stream Control Transmission Protocol
blacklist rds   # Reliable Datagram Sockets
blacklist tipc  # Transparent Inter-Process Communication

# Disable IPMI (common in server environments, rarely needed otherwise)
blacklist ipmi_si  # System Interface
blacklist ipmi_devintf  # Device Interface

# Disable floppy disk support (legacy hardware)
blacklist floppy

# Disable misc uncommon modules
blacklist n_hdlc       # HDLC line discipline
blacklist joydev       # Joystick devices
blacklist vfat         # FAT/ExFAT filesystem


update-initramfs -u

echo "done."
