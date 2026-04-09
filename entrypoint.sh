#!/bin/bash
set -e

echo "=== sipgate SIP Bridge ==="
echo "sipgate User: ${SIPGATE_USER}"
echo "AI Platform:  ${AI_SIP_HOST}:${AI_SIP_PORT} (${AI_SIP_TRANSPORT})"
echo "=========================="

# Template pjsip.conf mit env vars befüllen
envsubst '${SIPGATE_USER} ${SIPGATE_PASS} ${AI_SIP_HOST} ${AI_SIP_PORT} ${AI_SIP_TRANSPORT}' \
  < /opt/config/pjsip.conf.tmpl \
  > /etc/asterisk/pjsip.conf

# Statische Configs kopieren
cp /opt/config/extensions.conf /etc/asterisk/extensions.conf
cp /opt/config/modules.conf /etc/asterisk/modules.conf

# Rechte setzen
chown -R asterisk:asterisk /etc/asterisk/

echo "Config geschrieben, starte Asterisk..."
exec asterisk -f -vvv
