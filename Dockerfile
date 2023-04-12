# Use the official Alpine image as the base
FROM alpine:3.17

# Install necessary packages
RUN apk add --no-cache \
        tinyproxy \
        wireguard-tools \
        iptables \
        iproute2 \
        jq \
        curl \
        openresolv \
        ca-certificates

# Copy the entrypoint script and the Tinyproxy configuration
COPY entrypoint.sh /entrypoint.sh
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
COPY profiles /etc/wireguard/profiles

# Mount the Docker volume for the access logs
VOLUME /tinyproxy-logs

# Set the entrypoint script permissions
RUN chmod +x /entrypoint.sh

# Expose the Tinyproxy proxy port
EXPOSE 8888

# Set the entrypoint script as the container's entrypoint
ENTRYPOINT ["/entrypoint.sh"]
