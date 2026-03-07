# docker-network-toolbox

A minimal Debian-based Docker image packed with common network troubleshooting tools. Pull it onto any server for diagnostics without installing packages on the host or leaving tooling behind after the fact.

## Tools Included

| Tool | Package | Purpose |
|---|---|---|
| `ping` | `iputils-ping` | ICMP reachability testing |
| `traceroute` | `traceroute` | Hop-by-hop path tracing |
| `mtr` | `mtr` | Real-time combined ping + traceroute |
| `ip` | `iproute2` | Interface, route, and socket info |
| `ifconfig` / `netstat` | `net-tools` | Legacy interface and connection stats |
| `ss` | `iproute2` | Socket and connection statistics |
| `dig` / `nslookup` | `dnsutils` | DNS lookups and debugging |
| `curl` | `curl` | HTTP/HTTPS testing and transfers |
| `wget` | `wget` | File downloads and HTTP checks |
| `nmap` | `nmap` | Port scanning and host discovery |
| `tcpdump` | `tcpdump` | Packet capture and inspection |
| `iperf3` | `iperf3` | Network bandwidth testing |
| `nc` | `netcat-openbsd` | Raw TCP/UDP connections, port testing |
| `telnet` | `telnet` | Basic TCP connectivity checks |
| `whois` | `whois` | Domain and IP registration lookup |

## Building

```bash
docker build -t network-toolbox .
```

## Usage

### Interactive shell (most common)

```bash
docker run --rm -it --network host network-toolbox
```

> `--network host` gives the container direct access to the host's network interfaces, which is required for tools like `tcpdump` and `iperf3` to work properly.

### Run a single command

```bash
docker run --rm --network host network-toolbox -c "ping -c 4 8.8.8.8"
docker run --rm --network host network-toolbox -c "dig example.com"
docker run --rm --network host network-toolbox -c "nmap -sV 192.168.1.1"
docker run --rm --network host network-toolbox -c "ss -tulnp"
```

### Packet capture with tcpdump

`tcpdump` requires elevated capabilities:

```bash
docker run --rm -it --network host \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  network-toolbox -c "tcpdump -i eth0 -n"
```

### iperf3 bandwidth test

On the server (receiver):

```bash
docker run --rm -it --network host network-toolbox -c "iperf3 -s"
```

On the client (sender):

```bash
docker run --rm -it --network host network-toolbox -c "iperf3 -c <server-ip>"
```

### DNS troubleshooting

```bash
docker run --rm --network host network-toolbox -c "dig +trace example.com"
docker run --rm --network host network-toolbox -c "dig @8.8.8.8 example.com"
```

## Notes

- **Architecture:** `linux/amd64`
- **Base image:** `debian:stable-slim`
- Drops into `/bin/sh` by default
- `--network host` is recommended for most use cases so tools see real interface names and traffic
- `--rm` ensures the container is removed after exit, leaving nothing behind on the host
- Scope `nmap` and `tcpdump` usage to authorized targets only
