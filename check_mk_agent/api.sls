# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

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

/etc/rc0.d/K25delete-host-check_mk.sh:
  file.symlink:
    - target: /usr/local/bin/delete-host-check_mk.sh

/etc/rc3.d/S25add-host-check_mk.sh:
  file.symlink:
    - target: /usr/local/bin/add-host-check_mk.sh

/etc/rc5.d/S25add-host-check_mk.sh:
  file.symlink:
    - target: /usr/local/bin/add-host-check_mk.sh

add-host-at-first-run:
  cmd.run:
    - name: /usr/local/bin/add-host-check_mk.sh
    - creates: /etc/check_mk/firstrun
    - require:
      - sls: check_mk_agent.plugins
