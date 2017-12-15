#!/bin/bash
vhostspath="/var/www/vhosts"
vhostsused=$(df -m | grep "${vhostspath}" | tr -s ' ' | cut -d ' ' -f3)
if [ "${vhostsused}" = "" ]; then
  vhostsused=$(du -sm "${vhostspath}" | awk '{print $1}')
else
  vhostsused="${vhostsused}M"
fi

echo '[{'
echo -n "\"CaptureTime\": \"$(date +%Y-%m-%dT%H:%M:%SZ)\","
echo -n "\"TypeName\": \"Custom:WordPressDiskUsageAmount\","
echo -n "\"SchemaVersion\": \"1.0\","
echo -n "\"Content\": ["
echo "{\"${vhostspath}\":\"${vhostsused}\"}"
echo ""
echo "]"
echo "}]"
