FROM --platform=linux/amd64 debian:stable-slim

LABEL maintainer="skyler-v1dot0"
LABEL description="Network troubleshooting toolbox for server diagnostics"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Connectivity & routing
    iputils-ping \
    traceroute \
    mtr \
    iproute2 \
    net-tools \
    # DNS
    dnsutils \
    # HTTP/transfer
    curl \
    wget \
    # Port scanning
    nmap \
    # Packet capture
    tcpdump \
    # Bandwidth testing
    iperf3 \
    # Netcat / raw TCP
    netcat-openbsd \
    # Telnet
    telnet \
    # WHOIS
    whois \
    # Shell utilities
    procps \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ENTRYPOINT ["/bin/sh"]
