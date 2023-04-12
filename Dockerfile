# Use the official Alpine image as the base
FROM alpine:3.17

# Install necessary packages
RUN apk add --no-cache \
        squid \
        wireguard-tools \
        iptables \
        iproute2 \
        jq \
        curl \
        openresolv \
        ca-certificates

# Copy the entrypoint script and the Squid configuration
COPY entrypoint.sh /entrypoint.sh
COPY squid.conf /etc/squid/squid.conf
COPY profiles /etc/wireguard/profiles

# Mount the Docker volume for the access logs
VOLUME /squid-logs

# Set the entrypoint script permissions
RUN chmod +x /entrypoint.sh

# Expose the Squid proxy port
EXPOSE 3128

# Set the entrypoint script as the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]
