#!/bin/bash



### BEGIN INIT INFO
# Provides:   check_mk_agent   
# Required-Start: $remote_fs $network $xinetd
# Required-Stop:  $remote_fs $network
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Description:    check_mk - Remove Host on stop
### END INIT INFO

curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=delete_host&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}" -d 'request={"hostname": "{{ grains['fqdn'] }}"}'
curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=activate_changes&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}&allow_foreign_changes=1" 
