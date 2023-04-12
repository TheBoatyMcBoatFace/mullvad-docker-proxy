#!/bin/sh

# Select a random profile
PROFILE=$(ls /etc/wireguard/profiles | shuf -n 1)
echo "Using profile: ${PROFILE}"

# Copy the selected profile to wg0.conf and replace the private key placeholder
cp "/etc/wireguard/profiles/${PROFILE}" /etc/wireguard/wg0.conf
sed -i "s|PrivateKey_PLACEHOLDER|${PRIVATE_KEY}|g" /etc/wireguard/wg0.conf

# Set up the Wireguard interface
ip link add wg0 type wireguard
wg setconf wg0 /etc/wireguard/wg0.conf
ip link set wg0 up
ip route add default dev wg0 table 51820
ip rule add not fwmark 51820 table 51820
ip rule add table main suppress_prefixlength 0

# Configure DNS using openresolv
DNS_SERVERS=$(wg show wg0 allowed-ips | grep -oP '(?<=\(main\) )[0-9a-fA-F:.]*')
for DNS_SERVER in $DNS_SERVERS; do
    echo "nameserver $DNS_SERVER" >> /etc/resolv.conf
done

# Get the primary IP address of the Docker container
PRIMARY_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n 1)

# Update the squid.conf file with the primary IP address
sed -i "s|tcp_outgoing_address .*|tcp_outgoing_address ${PRIMARY_IP}|g" /etc/squid/squid.conf

ln -sf /dev/stdout /var/log/squid/access.log && \
ln -sf /var/log/squid/access.log /squid-logs/access.log

# Start the Squid proxy
exec squid -N -f /etc/squid/squid.conf
