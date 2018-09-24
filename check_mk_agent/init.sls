# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

include:
  - check_mk_agent.api
  - check_mk_agent.plugins
  - check_mk_agent.config
xinetd:
  pkg.installed

{% if grains['os_family'] == 'Debian' %}
check_mk-deb-present:
  file.managed:
    {% if salt['pillar.get']('check_mk_agent:k8s') %}  
    - source: salt://check_mk_agent/files/deb/check-mk-agent_1.4.0p33-1_all.deb
    - name: /var/cache/apt/archives/check-mk-agent_1.4.0p33-1_all.deb
    {% else %}
    - source: salt://check_mk_agent/files/deb/check-mk-agent_1.5.0p2-1_all.deb
    - name: /var/cache/apt/archives/check-mk-agent_1.5.0p2-1_all.deb
    {% endif %}
   

install-cmk-agent:
  cmd.run:
    {% if salt['pillar.get']('check_mk_agent:k8s') %}
    - name: dpkg -i /var/cache/apt/archives/check-mk-agent_1.4.0p33-1_all.deb
    {% else %}
    - name: dpkg -i /var/cache/apt/archives/check-mk-agent_1.5.0p2-1_all.deb
    {% endif %}
    - require:
      - file: check_mk-deb-present
    - onchanges:
      - file: check_mk-deb-present
    
/usr/lib/check_mk_agent/plugins/mk_apt:
  file.absent

    
/usr/lib/check_mk_agent/plugins/14400/mk_apt:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_apt
    - mode: 755
    - makedirs: True

/usr/lib/check_mk_agent/local/check_reboot:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/check_reboot
    - mode: 755

{% elif grains['os_family'] == 'RedHat' %}

firewall-cmd --zone=public --add-port=6556/tcp --permanent:
  cmd.run:
    - name: firewall-cmd --zone=public --add-port=6556/tcp --permanent

xinetd_service:
  service.running:
    - enable: True 
    - name: xinetd

check_mk-rpm-present:
    file.managed:
      - source: salt://check_mk_agent/files/rpm/check-mk-agent-1.4.0p24-1.noarch.rpm
      - name: /root/check-mk-agent-1.4.0p24-1.noarch.rpm
  
rpm -i /root/check-mk-agent-1.4.0p24-1.noarch.rpm:
  cmd.run: 
    - name: rpm -i /root/check-mk-agent-1.4.0p24-1.noarch.rpm
    - onchanges:
      - file: check_mk-rpm-present
{% endif %}


/usr/lib/check_mk_agent/plugins/mk_inventory:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_inventory
    - mode: 755

/usr/lib/check_mk_agent/plugins/mk_logins:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_logins
    - mode: 755

/usr/lib/check_mk_agent/plugins/netstat:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/netstat
    - mode: 755


/etc/check_mk/mrpe.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/mrpe.jinja
    - mode: 644
    - template: jinja
