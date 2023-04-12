#!/bin/sh

# Select a random profile
PROFILE=$(ls /etc/wireguard/profiles | shuf -n 1)
echo "Using profile: ${PROFILE}"

# Copy the selected profile to wg0.conf and replace the private key placeholder
cp "/etc/wireguard/profiles/${PROFILE}" /etc/wireguard/wg0.conf
sed -i "s|PrivateKey_PLACEHOLDER|${PRIVATE_KEY}|g" /etc/wireguard/wg0.conf

# Set up the Wireguard interface
wg-quick up wg0

# Get the primary IP address of the Docker container
PRIMARY_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n 1)

# Update the squid.conf file with the primary IP address
sed -i "s|tcp_outgoing_address .*|tcp_outgoing_address ${PRIMARY_IP}|g" /etc/squid/squid.conf

ln -sf /dev/stdout /var/log/squid/access.log && \
ln -sf /var/log/squid/access.log /squid-logs/access.log

# Start the Squid proxy
exec squid -N -f /etc/squid/squid.conf
