# vim: sts=2 ts=2 sw=2 et ai
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}

/etc/check_mk/mrpe.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/mrpe.jinja
    - mode: 644
    - template: jinja

{% if 'encryption' in check_mk_agent %}
/etc/check_mk/encryption.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/encryption.cfg
    - mode: 640
    - template: jinja
    - context:
        check_mk_agent: {{ check_mk_agent|json(sort_keys=False) }}
{% else %}
/etc/check_mk/encryption.cfg:
  file.absent
{% endif %}
