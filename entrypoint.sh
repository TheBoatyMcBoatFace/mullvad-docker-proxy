#!/bin/sh

# Select a random profile
PROFILE=$(ls /etc/wireguard/profiles | shuf -n 1)
echo "Using profile: ${PROFILE}"

# Copy the selected profile to wg0.conf and replace the private key placeholder
cp "/etc/wireguard/profiles/${PROFILE}" /etc/wireguard/wg0.conf
sed -i "s|PrivateKey_PLACEHOLDER|${PRIVATE_KEY}|g" /etc/wireguard/wg0.conf

# Set up the Wireguard interface
wg-quick up /etc/wireguard/wg0.conf

# Start the Tinyproxy
exec tinyproxy -c /etc/tinyproxy/tinyproxy.conf
