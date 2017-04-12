#!/bin/bash
_ssl_confs=$(find /etc/nginx/conf.d -type f -name '*.conf' | xargs grep 'ssl' | grep -v '^#' | grep listen | awk '{print $1}' | sed 's/://g' | sort | uniq)
count=1
echo '[{'
echo -n "\"CaptureTime\": \"$(date +%Y-%m-%dT%H:%M:%SZ)\","
echo -n "\"TypeName\": \"Custom:NginxSSLDomainList\","
echo -n "\"SchemaVersion\": \"1.0\","
echo -n "\"Content\": ["
for _ssl_conf in $_ssl_confs; do
  if [ -f $_ssl_conf ]; then
    _server_names=$(cat ${_ssl_conf} | grep 'server_name' | grep -v '$server_name' | awk '{print $2}' | sed 's/;//g' | sort | uniq)
    for _server_name in $_server_names; do
      if [ ${count} != '1' ]; then
        echo ','
      fi
      echo -n "{  \"domain\": \"${_server_name}\"}"
      let count++
    done
  fi
done
echo ""
echo "]"
echo "}]"
