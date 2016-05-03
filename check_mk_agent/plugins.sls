# vim: sts=2 ts=2 sw=2 et ai ft=sls
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}


{% if salt['pillar.get']('check_mk_agent:plugins:nginx') %}

/etc/check_mk/nginx_status.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/nginx_status.cfg
    - mode: 644

/usr/lib/check_mk_agent/plugins/nginx_status:
  file.managed:
    - source: salt://check_mk_agent/files/nginx_status
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:mysql') %}

/etc/check_mk/mysql.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/mysql.jinja
    - mode: 644
    - template: jinja

/usr/lib/check_mk_agent/plugins/mk_mysql:
  file.managed:
    - source: salt://check_mk_agent/files/mk_mysql
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:apache') %}

/etc/check_mk/apache_status.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/apache_status.cfg
    - mode: 644

/usr/lib/check_mk_agent/plugins/apache_status:
  file.managed:
    - source: salt://check_mk_agent/files/apache_status
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:fileinfo') %}

/etc/check_mk/fileinfo.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/fileinfo.jinja
    - mode: 644
    - template: jinja

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:haproxy') %}

/usr/lib/check_mk_agent/local/haproxy.py:
  file.managed:
    - source: salt://check_mk_agent/files/haproxy.py
    - mode: 755

/usr/lib/check_mk_agent/local/haproxychecks.py:
  file.managed:
    - source: salt://check_mk_agent/files/haproxychecks.py
    - mode: 755

{% endif %}
 
{% if salt['pillar.get']('check_mk_agent:plugins:postgres') %}

/usr/lib/check_mk_agent/plugins/mk_postgres:
  file.managed:
    - source: salt://check_mk_agent/files/mk_postgres
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:supervisor') %}

install-sensu-supervisor-gem:
  gem.installed:
    - names:
      - sensu-plugins-supervisor
      
{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:rabbitmq') %}

install-sensu-rabbitmq-gem:
  gem.installed:
    - names:
      - sensu-plugins-rabbitmq

{% endif %}
