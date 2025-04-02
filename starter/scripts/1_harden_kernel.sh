#!/bin/bash

sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0


sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1


sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv6.conf.all.accept_source_route=0
sysctl -w net.ipv6.conf.default.accept_source_route=0


sysctl -w net.ipv4.conf.conf.all.log_martians=1
sysctl -w net.ipv4.conf.conf.default.log_martians=1
sysctl -w net.ipv6.conf.conf.all.log_martians=1
sysctl -w net.ipv6.conf.conf.default.log_martians=1


sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv6.icmp_echo_ignore_broadcasts=1

sysctl -w kernel.randomize_va_space=2
sysctl -w vm.mmap_min_addr=65536

echo 1 > /proc/sys/kernel/modules_disabled

sysctl -w kernel.yama.ptrace_scope=2
sysctl -w kernel.unprivileged_bpf_disabled=1
sysctl -w kernel.dmesg_restrict=1
sysctl -w kernel.perf_event_paranoid=3
sysctl -w kernel.random.write_wakeup_threshold=128


sysctl --system

echo "done."


