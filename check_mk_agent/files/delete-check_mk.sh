#!/bin/bash

# chkconfig: 345 90 90
# description: check_mk - Remove Host in stop

### BEGIN INIT INFO
# Provides:       
# Required-Start: $remote_fs $network
# Required-Stop:  $remote_fs $network
# Default-Start:
# Default-Stop:   0 1 6
# Description:    check_mk - Remove Host on stop
### END INIT INFO

curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=delete_host&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}" -d 'request={"hostname": "{{ grains['fqdn'] }}"}'
sleep 5
curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=activate_changes&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}" 
