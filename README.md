# sipgate SIP Bridge

Minimal Asterisk container that connects sipgate trunking to any AI voice platform.

**What does it do?** Registers with sipgate, accepts incoming calls, and forwards them via SIP to the AI platform of your choice.

## Quick Start

```bash
# 1. Clone / unpack
cd sip-bridge

# 2. Create .env
cp .env.example .env

# 3. Edit .env — fill in your values:
#    EXTERNAL_IP, SIPGATE_USER, SIPGATE_PASS, AI_SIP_HOST

# 4. Start
docker compose up -d

# 5. Check logs & status
docker logs -f sip-bridge
```

## Configuration (.env)

| Variable | Description | Example |
|---|---|---|
| `EXTERNAL_IP` | Public IP of your server | `1.2.3.4` |
| `SIPGATE_USER` | sipgate trunk account | `1234567t0` |
| `SIPGATE_PASS` | sipgate password | `secret123` |
| `AI_SIP_HOST` | SIP host of the AI platform | `sip.rtc.elevenlabs.io` |
| `AI_SIP_PORT` | SIP port (usually 5060) | `5060` |
| `AI_SIP_TRANSPORT` | Transport protocol | `tcp` |

## Requirements

- VPS or server with a **public IP address** and Docker installed (e.g. Hetzner CX22, ~€4/month)
- Set `EXTERNAL_IP` to your server's public IP — Asterisk uses it to announce the correct RTP address behind Docker NAT

## Firewall

```bash
ufw allow from 217.10.68.0/24 to any port 5060    # sipgate signaling
ufw allow from 217.116.112.0/20 to any port 5060  # sipgate signaling
ufw allow 5060/tcp                                 # AI platform
ufw allow 10000:10100/udp                          # RTP media
```

## Debugging

```bash
docker exec sip-bridge asterisk -rx "pjsip show registrations"  # sipgate registration
docker exec sip-bridge asterisk -rx "pjsip show endpoints"      # endpoints
docker exec sip-bridge asterisk -rx "core show channels"         # active calls

# Interactive CLI
docker exec -it sip-bridge asterisk -rvvv
```

## AI Platform Setup

Most AI voice platforms have an "Import number from SIP trunk" option. Enter your VPS's public IP as the address.

### Authentication

By default no SIP credentials are configured — the AI platform should use IP-based ACL authentication with "Allow all addresses". If your platform requires digest auth, set `AI_SIP_USER` and `AI_SIP_PASS` in `.env`.

### Supported Platforms

| Platform | SIP Host | Port | Transport |
|---|---|---|---|
| ElevenLabs | `sip.rtc.elevenlabs.io` | 5060 | tcp |
| Vapi | `sip.vapi.ai` | 5060 | tcp |
| Retell | `sip.retellai.com` | 5060 | tcp |
| Bland AI | `sip.bland.ai` | 5060 | tcp |

## Resources

~30–50 MB RAM, <1% CPU idle, ~100 MB disk.
