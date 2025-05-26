#!/bin/bash

vms=(
  "Domain-0"
  "sys-usb"
  "dda"
  "ddt"
  "def-d"
  "def-disp"
  "default-dvm"
  "fedora-41-xfce"
  "fwt"
  "net-starter"
  "sna"
  "snt"
  "starter"
  "sys-firewall"
  "sys-net"
  "sys-whonix"
  "whonix-gateway-17"
  "whonix-workstation-17"
)

for vm in "${vms[@]}"; do
  sudo virsh dumpxml $vm > ./vm-xmls/$vm.xml
done

sed -i  "s|console=hvc0| |g" ./vm-xmls/*
sed -i  "s|rd_NO_PLYMOUTH| |g" ./vm-xmls/*
sed -i  "s|rd.plymouth.enable=0| |g" ./vm-xmls/*
sed -i  "s|clocksource=tsc| |g" ./vm-xmls/*
sed -i  "s|xen_scrub_pages=0|xen_scrub_pages=1|g" ./vm-xmls/*
sed -i  "s|swiotlb=2048| |g" ./vm-xmls/*
sed -i  "s|<boot dev='cdrom'>| |g" ./vm-xmls/*
sed -i  "s|type='rom'|readonly='yes'|g" ./vm-xmls/*
sed -i  "s|</pae>||g" ./vm-xmls/*
sed -i  "s|<viridian/>| |g" ./vm-xmls/*
sed -i  "s|<apci/>| |g" ./vm-xmls/*
#sed -i  "s|mode='host-passthrough'| |g" ./vm-xmls/*
sed -i  "s|<feature policy='disable' name='svm'/>||g" ./vm-xmls/*
sed -i  "s|<feature policy='disable' name='vmx'/>|<feature policy='require' name='vmx'/>|g" ./vm-xmls/*
sed -i  "s|<feature policy='require' name='invtsc'/>||g" ./vm-xmls/*
sed -i  "s|<clock offset='utc' adjustment='reset'>|<clock>|g" ./vm-xmls/*
sed -i  "s|<timer name='tsc' mode='native'/>|<timer mode='native'/> |g" ./vm-xmls/*
sed -i  "s|<on_reboot>destroy</on_reboot>| |g"  ./vm-xmls/*
sed -i  "s|<video>||g" ./vm-xmls/*
sed -i  "s|</video>||g" ./vm-xmls/*
sed -i  "s|<model type='vga' vram='16384' heads='1' primary='yes'/>||g" ./vm-xmls/*
sed -i  "s|<memballoon model='xen'/>||g" ./vm-xmls/*


echo "done."
