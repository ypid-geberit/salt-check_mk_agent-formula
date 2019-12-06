# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

include:
  - systemd.reload

{% if grains['os_family'] == 'Debian' %}
install_checkmk_agent:
  pkg.installed:
    - source: salt://check_mk_agent/files/deb/check-mk-agent_2019.09.23-1_all.deb

{% elif grains['os_family'] in [ 'RedHat', 'Suse' ] %}

{% if grains['os_family'] == 'RedHat' %}
firewall-cmd --zone=public --add-port=6556/tcp --permanent:
  cmd.run:
    - name: firewall-cmd --zone=public --add-port=6556/tcp --permanent
{% endif %}

install_checkmk_agent:
  pkg.installed:
    - skip_verify: True
    - sources:
      - check-mk-agent: salt://check_mk_agent/files/rpm/check-mk-agent-1.6.0-1.noarch.rpm

{% endif %}


{% if check_mk_agent.trigger_type == 'xinetd' %}
install_xinetd:
  pkg.installed

/etc/xinetd.d/check_mk:
  file.managed:
    - source:
      - salt://check_mk_agent/files/cfg/xinetd.conf.j2
    - mode: 644
    - template: jinja
    - create: False

{% if grains['os_family'] == 'RedHat' %}
xinetd_service:
  service.running:
    - enable: True
    - name: xinetd
{% endif %}

{% endif %}
