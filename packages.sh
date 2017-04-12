#!/bin/bash
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e "s/.$//g")
INSTANCEID=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id)
_yum_update=$(sudo yum updateinfo list | wc -l)
_sec_update=$(sudo yum updateinfo list --security | grep ALAS | wc -l)
_wp_cli_version=$(/usr/local/bin/wp --allow-root --version | sed 's/^WP-CLI //g')
_content=''
_content="${_content}[{"
_content="${_content}\"CaptureTime\": \"$(date +%Y-%m-%dT%H:%M:%SZ)\","
_content="${_content}\"TypeName\": \"Custom:Application\","
_content="${_content}\"SchemaVersion\": \"1.0\","
_content="${_content}\"Content\": ["
_content="${_content}{ \"yum_update_num\": \"${_yum_update}\",\"yum_security_update_num\": \"${_sec_update}\", \"wp_cli_version\": \"${_wp_cli_version}\"}"
_content="${_content}"
_content="${_content}]"
_content="${_content}}]"
echo $_content
