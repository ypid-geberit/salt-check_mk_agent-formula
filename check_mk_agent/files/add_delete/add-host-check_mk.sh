#! /bin/bash
{% if salt['pillar.get']('check_mk_agent:hostip') %}
{%- set webtrustip = salt['pillar.get']('check_mk_agent:hostip') %}
{% else %}
{%- set webtrustip = salt.network.ip_addrs(cidr='192.168.10.0/24')[0] %}
{% endif %}
touch /etc/check_mk/firstrun


curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=add_host&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}" -d 'request={"attributes": {"ipaddress": "{{ webtrustip }}","tag_agent": "cmk-agent", "tag_criticality": "{{ salt['pillar.get']('check_mk_agent:criticality') }}"}, "folder": "{{ salt['pillar.get']('check_mk_agent:folder') }}", "hostname": "{{ grains['fqdn'] }}" }'
curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=discover_services&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}&mode=fixall" -d 'request={"hostname": "{{ grains['fqdn'] }}"}'
curl "http://{{ salt['pillar.get']('check_mk_agent:server') }}/{{ salt['pillar.get']('check_mk_agent:site') }}/check_mk/webapi.py?action=activate_changes&_username={{ salt['pillar.get']('check_mk_agent:api-user') }}&_secret={{ salt['pillar.get']('check_mk_agent:api-secret') }}&allow_foreign_changes=1" 
