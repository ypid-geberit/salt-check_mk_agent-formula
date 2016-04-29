#! /bin/bash
#
# skeleton  example file to build /etc/init.d/ scripts.
#       This file should be used to construct scripts for /etc/init.d.
#
#       Written by Miquel van Smoorenburg <miquels@cistron.nl>.
#       Modified for Debian
#       by Ian Murdock <imurdock@gnu.ai.mit.edu>.
#               Further changes by Javier Fernandez-Sanguino <jfs@debian.org>
#
# Version:  @(#)skeleton  1.9  26-Feb-2001  miquels@cistron.nl
#
### BEGIN INIT INFO
# Provides:          check_mk_agent
# Required-Start:    $remote_fs $network $named
# Required-Stop:     $remote_fs $network $named
# Default-Start:     2 3 4 5
# Default-Stop:      
# Short-Description: add host to check_mk on boot
# Description:       add host to check_mk on boot
#              
### END INIT INFO

touch /etc/check_mk/firstrun

curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=add_host&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}" -d 'request={"attributes": {"ipaddress": "{{ salt['grains.get']('ipv4')[2] }}","tag_agent": "cmk-agent", "tag_criticality": "prod"}, "folder": "{{ salt['pillar.get']('check_mk_agent:folder') }}", "hostname": "{{ grains['fqdn'] }}" }'
curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=activate_changes&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}" 
