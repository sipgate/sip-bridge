#!/bin/bash
set -e

echo "=== sipgate SIP Bridge ==="
echo "sipgate User: ${SIPGATE_USER}"
echo "AI Platform:  ${AI_SIP_HOST}:${AI_SIP_PORT} (${AI_SIP_TRANSPORT})"
echo "=========================="

# Render configs from templates
envsubst '${SIPGATE_USER} ${SIPGATE_PASS} ${AI_SIP_HOST} ${AI_SIP_PORT} ${AI_SIP_TRANSPORT}' \
  < /opt/config/pjsip.conf.tmpl \
  > /etc/asterisk/pjsip.conf

envsubst '${EXTERNAL_IP}' \
  < /etc/asterisk/rtp.conf.tmpl \
  > /etc/asterisk/rtp.conf

# Copy static configs
cp /opt/config/extensions.conf /etc/asterisk/extensions.conf
cp /opt/config/modules.conf /etc/asterisk/modules.conf

# Set permissions
chown -R asterisk:asterisk /etc/asterisk/

echo "Config written, starting Asterisk..."
exec asterisk -f -vvv
