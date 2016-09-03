# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

include:
  - check_mk_agent
  - check_mk_agent.plugins

/usr/local/bin/add-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/add-host-check_mk.sh
    - mode: 755
    - template: jinja

/usr/local/bin/delete-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/delete-host-check_mk.sh
    - mode: 755
    - template: jinja

{% if grains['init'] == 'upstart' %}

/etc/init/add-to-cmk.conf:
  file.managed:
    - source: salt://check_mk_agent/files/add-to-cmk.conf
    - mode: 644

/etc/init/del-from-cmk.conf:
  file.managed:
    - source: salt://check_mk_agent/files/del-from-cmk.conf
    - mode: 644

{% elif grains['init'] == 'systemd' %}

/etc/systemd/system/add-to-cmk.service:
  file.managed:
    - source: salt://check_mk_agent/files/add-to-cmk.service
    - mode: 644

/etc/systemd/system/del-from-cmk.service:
  file.managed:
    - source: salt://check_mk_agent/files/del-from-cmk.service
    - mode: 644

enable_systemd_scripts:
  cmd.run:
    name: systemdctl enable add-to-cmk.service del-from-cmk.service
    creates: /etc/systemd/system/multi-user.target.wants/add-to-cmk.service


{% endif %}

add-host-at-first-run:
  cmd.run:
    - name: /usr/local/bin/add-host-check_mk.sh
    - creates: /etc/check_mk/firstrun

/etc/rc0.d/K01delete-host-check_mk.sh:
  file.absent

/etc/init.d/delete-host-check_mk.sh:
  file.absent

/etc/init.d/add-host-check_mk.sh:
  file.absent

/etc/rc6.d/K01delete-host-check_mk.sh:
  file.absent

/etc/rc2.d/S25add-host-check_mk.sh:
  file.absent

/etc/rc3.d/S25add-host-check_mk.sh:
  file.absent

/etc/rc4.d/S25add-host-check_mk.sh:
  file.absent

/etc/rc5.d/S25add-host-check_mk.sh:
  file.absent
