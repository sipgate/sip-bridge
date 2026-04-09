# sipgate SIP Bridge

Minimaler Asterisk-Container, der sipgate Trunking mit einer beliebigen AI-Voice-Plattform verbindet.

**Was macht das?** Registriert sich bei sipgate, nimmt eingehende Calls an und leitet sie per SIP an die AI-Plattform weiter.

## Quick Start

```bash
# 1. Repo klonen / entpacken
cd sip-bridge

# 2. .env anlegen
cp .env.example .env

# 3. .env anpassen — eigene Werte eintragen:
#    SIPGATE_USER, SIPGATE_PASS, AI_SIP_HOST

# 4. Starten
docker compose up -d

# 5. Logs & Status prüfen
docker logs -f sip-bridge
```

## Konfiguration (.env)

| Variable | Beschreibung | Beispiel |
|---|---|---|
| `SIPGATE_USER` | sipgate Trunk-Account | `1234567t0` |
| `SIPGATE_PASS` | sipgate Passwort | `geheim123` |
| `AI_SIP_HOST` | SIP-Host der AI-Plattform | `sip.rtc.elevenlabs.io` |
| `AI_SIP_PORT` | SIP-Port (meist 5060) | `5060` |
| `AI_SIP_TRANSPORT` | Transportprotokoll | `tcp` |

## Voraussetzungen

- VPS mit öffentlicher IP und Docker (z.B. Hetzner CX22, ~4€/Monat)
- `network_mode: host` ist gesetzt — SIP/RTP läuft direkt über das Host-Netzwerk

## Firewall

```bash
ufw allow from 217.10.68.0/24 to any port 5060  # sipgate Signaling
ufw allow 5060/tcp                                # AI-Plattform
ufw allow 10000:10100/udp                         # RTP Media
```

## Debugging

```bash
# Asterisk CLI öffnen
docker exec -it sip-bridge asterisk -rvvv

# In der CLI:
pjsip show registrations     # sipgate Registration prüfen
pjsip show endpoints         # Endpoints anzeigen
core show channels            # Aktive Calls
```

## AI-Plattform Seite

Die meisten AI-Voice-Plattformen haben eine Option "Import number from SIP trunk". Dort die öffentliche IP des VPS als Adresse eintragen.

## Ressourcen

~30-50 MB RAM, <1% CPU idle, ~100 MB Disk.
