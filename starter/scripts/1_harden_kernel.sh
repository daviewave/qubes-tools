#!/bin/bash

# Disable acceptance of ICMP redirects (prevents man-in-the-middle attacks)
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0

# Enable reverse path filtering (protects against IP spoofing)
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1

# Disable source routing (minimizes attack vectors for spoofed packets)
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv6.conf.all.accept_source_route=0
sysctl -w net.ipv6.conf.default.accept_source_route=0

# Harden network stack against malformed packets
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1

# Disable unused protocols (focuses on rarely used ones)
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv6.conf.all.disable_ipv6=1

# Disable broadcast ICMP requests (prevents amplification attacks)
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1

# Harden memory protection (defense against buffer overflows and memory exploits)
sysctl -w kernel.randomize_va_space=2
sysctl -w vm.mmap_min_addr=65536

# Disable kernel module loading post-boot (locks down kernel integrity)
echo 1 > /proc/sys/kernel/modules_disabled

# Restrict ptrace usage to child processes (limits debugging abuse)
sysctl -w kernel.yama.ptrace_scope=2

# Disable unprivileged BPF usage (common attack vector for privilege escalation)
sysctl -w kernel.unprivileged_bpf_disabled=1

# Restrict dmesg access to root (protects kernel logs from unauthorized access)
sysctl -w kernel.dmesg_restrict=1

# Disable perf events for unprivileged users (minimizes information leakage)
sysctl -w kernel.perf_event_paranoid=3

# Enable entropy collection for cryptographic operations
sysctl -w kernel.random.write_wakeup_threshold=128


sysctl --system

echo "done."
