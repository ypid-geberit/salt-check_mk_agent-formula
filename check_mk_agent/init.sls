# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

xinetd:
  pkg.installed

check_mk-deb-present:
  file.managed:
    - source: salt://check_mk_agent/files/check-mk-agent_1.2.6p16-1_all.deb
    - name: /tmp/check-mk-agent_1.2.6p16-1_all.deb

dpkg -i /tmp/check-mk-agent_1.2.6p16-1_all.deb:
  cmd.run:
    - creates: /usr/bin/check_mk_agent
    - require: 
      - pkg: xinetd
    - watch:
      - service: xinetd

/usr/lib/check_mk_agent/plugins/mk_inventory:
  file.managed:
    - source: salt://check_mk_agent/files/mk_inventory
    - mode: 755

/usr/lib/check_mk_agent/plugins/mk_logins:
  file.managed:
    - source: salt://check_mk_agent/files/mk_logins
    - mode: 755

/usr/lib/check_mk_agent/local/check_reboot:
  file.managed:
    - source: salt://check_mk_agent/files/check_reboot
    - mode: 755

/etc/rc0.d/K25delete-check_mk.sh:
  file.managed:
    - mode: 755
    - source: salt://check_mk_agent/files/delete-check_mk.sh
    - template: jinja

/etc/rc3.d/S25add-check_mk.sh:
  file.managed:
    - mode: 755
    - source: salt://check_mk_agent/files/add-check_mk.sh
    - template: jinja

/etc/rc5.d/S25add-check_mk.sh:
  file.managed:
    - mode: 755
    - source: salt://check_mk_agent/files/add-check_mk.sh
    - template: jinja
