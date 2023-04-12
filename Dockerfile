# Use the official Ubuntu image as the base
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        squid \
        wireguard \
        wireguard-tools \
        iptables \
        iproute2 \
        jq \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script and the Squid configuration
COPY entrypoint.sh /entrypoint.sh
COPY squid.conf /etc/squid/squid.conf
COPY profiles /etc/wireguard/profiles

# Expose the Squid proxy port
EXPOSE 3128

# Set the entrypoint script as the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]
