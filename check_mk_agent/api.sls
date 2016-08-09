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

/etc/init.d/add-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/add-host-check_mk.sh
    - mode: 755
    - template: jinja

/usr/local/bin/delete-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/delete-host-check_mk.sh
    - mode: 755
    - template: jinja

/etc/init.d/delete-host-check_mk.sh:
  file.managed:
    - source: salt://check_mk_agent/files/delete-host-check_mk.sh
    - mode: 755
    - template: jinja

/etc/rc0.d/K02delete-host-check_mk.sh:
  file.symlink:
    - target: /etc/init.d/delete-host-check_mk.sh

/etc/rc6.d/K02delete-host-check_mk.sh:
  file.symlink:
    - target: /etc/init.d/delete-host-check_mk.sh

/etc/rc2.d/S25add-host-check_mk.sh:
  file.symlink:
    - target: /etc/init.d/add-host-check_mk.sh

/etc/rc3.d/S25add-host-check_mk.sh:
  file.symlink:
    - target: /etc/init.d/add-host-check_mk.sh

/etc/rc4.d/S25add-host-check_mk.sh:
  file.symlink:
    - target: /etc/init.d/add-host-check_mk.sh

/etc/rc5.d/S25add-host-check_mk.sh:
  file.symlink:
    - target: /etc/init.d/add-host-check_mk.sh

add-host-at-first-run:
  cmd.run:
    - name: /usr/local/bin/add-host-check_mk.sh
    - creates: /etc/check_mk/firstrun
