#!/bin/bash
_wp="sudo -u ec2-user /usr/local/bin/wp"
_wp_dirs=$(find /var/www/ -type f -name 'wp-load.php' -exec bash -c '_wp=$(echo {} | sed -e s/[^\/]*$//); echo "${_wp}";' \;)
count=1
echo '[{'
echo -n "\"CaptureTime\": \"$(date +%Y-%m-%dT%H:%M:%SZ)\","
echo -n "\"TypeName\": \"Custom:WordPressInformations\","
echo -n "\"SchemaVersion\": \"1.0\","
echo -n "\"Content\": ["
for _wp_dir in $_wp_dirs; do
  if [ -e $_wp_dir ]; then
    if $(${_wp} core is-installed --path=${_wp_dir}); then
      if [ ${count} != '1' ]; then
        echo ','
      fi
      _version=$(${_wp} core version --path=${_wp_dir})
      _siteurl=$(${_wp} option get siteurl --path=${_wp_dir})
      _home=$(${_wp} option get home --path=${_wp_dir})
      echo -n "{ \"wp_directory\": \"${_wp_dir}\", \"version\": \"${_version}\", \"home\": \"${_home}\", \"siteurl\": \"${_siteurl}\"}"
      let count++
    fi
  fi
done
echo ""
echo "]"
echo "}]"
