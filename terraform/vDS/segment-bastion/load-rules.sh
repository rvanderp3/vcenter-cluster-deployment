sudo dmesg -n 1
sudo cp /etc/iptables-rules /etc/sysconfig/iptables
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -p /etc/sysctl.conf 

sudo systemctl start iptables

sudo systemctl unmask dnsmasq
sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq