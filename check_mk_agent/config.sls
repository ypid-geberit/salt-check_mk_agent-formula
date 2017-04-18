# vim: sts=2 ts=2 sw=2 et ai

/etc/xinetd.d/check_mk:
  file.managed:
    - source:
      - salt://check_mk_agent/files/cfg/xinetd.conf.j2
    - mode: 644
    - template: jinja
    - create: False
