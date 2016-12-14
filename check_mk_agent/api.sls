# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

include:
  - check_mk_agent
  - check_mk_agent.plugins

/usr/local/bin/add-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/add_delete/add-host-check_mk.sh
    - mode: 755
    - template: jinja

/usr/local/bin/delete-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/add_delete/delete-host-check_mk.sh
    - mode: 755
    - template: jinja

{% if grains['init'] == 'upstart' %}

/etc/init/add-to-cmk.conf:
  file.managed:
    - source: salt://check_mk_agent/files/upstart/add-to-cmk.conf
    - mode: 644

/etc/init/del-from-cmk.conf:
  file.managed:
    - source: salt://check_mk_agent/files/upstart/del-from-cmk.conf
    - mode: 644

{% elif grains['init'] == 'systemd' %}

/etc/systemd/system/add-to-cmk.service:
  file.managed:
    - source: salt://check_mk_agent/files/systemd/add-to-cmk.service
    - mode: 644

/etc/systemd/system/del-from-cmk.service:
  file.managed:
    - source: salt://check_mk_agent/files/systemd/del-from-cmk.service
    - mode: 644

enable_systemd_scripts:
  cmd.run:
    - name: systemctl enable add-to-cmk.service del-from-cmk.service
    - creates: /etc/systemd/system/multi-user.target.wants/add-to-cmk.service


{% endif %}

add-host-at-first-run:
  cmd.run:
    - name: /usr/local/bin/add-host-check_mk.sh
    - creates: /etc/check_mk/firstrun

/etc/check_mk/firstrun:
  file.managed:
    - mode: 666
