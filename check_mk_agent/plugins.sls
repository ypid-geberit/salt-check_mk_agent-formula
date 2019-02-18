# vim: sts=2 ts=2 sw=2 et ai ft=sls
{% from "check_mk_agent/map.jinja" import check_mk_agent with context %}


{% if salt['pillar.get']('check_mk_agent:plugins:nginx') %}

/etc/check_mk/nginx_status.cfg:
  file.managed:
    - source:
      - salt://check_mk_agent/files/cfg/nginx_status.jinja
    - mode: 644
    - template: jinja

/usr/lib/check_mk_agent/plugins/nginx_status:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/nginx_status
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:mysql') %}

/etc/check_mk/mysql.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/mysql.jinja
    - mode: 644
    - template: jinja

/usr/lib/check_mk_agent/plugins/mk_mysql:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_mysql
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:apache') %}

/etc/check_mk/apache_status.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/apache_status.cfg
    - mode: 644

/usr/lib/check_mk_agent/plugins/apache_status:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/apache_status
    - mode: 755

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:fileinfo') %}

/etc/check_mk/fileinfo.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/fileinfo.jinja
    - mode: 644
    - template: jinja

{% endif %}


{% if salt['pillar.get']('check_mk_agent:plugins:postgres') %}

/usr/lib/check_mk_agent/plugins/mk_postgres:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_postgres
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

{% if salt['pillar.get']('check_mk_agent:plugins:check-http-ping') %}

install-sensu-http-gem:
  gem.installed:
    - names:
      - sensu-plugins-http

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:varnish') %}

perl:
  pkg.installed

installSwitch:
  cmd.run:
    - env:
      - PERL_AUTOINSTALL='--defaultdeps'
      - PERL_MM_USE_DEFAULT=1
    - name: perl -MCPAN -e 'install Switch'
    - creates: /usr/local/share/man/man3/Switch.3pm


/usr/local/bin/check-varnish.pl:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/check-varnish.pl
    - mode: 755

{% endif %}


{% if salt['pillar.get']('check_mk_agent:plugins:jolokia') %}

/usr/lib/check_mk_agent/plugins/mk_jolokia:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_jolokia
    - mode: 755

/var/lib/tomcat8/webapps/jolokia.war:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/jolokia-war-1.3.5.war
    - mode: 644

{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:apt') %}

/usr/lib/check_mk_agent/plugins/3600/mk_apt:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_apt
    - mode: 755
    - makedirs: True
    - dir_mode: 755

{% endif %}


{% if salt['pillar.get']('check_mk_agent:plugins:docker') %}

/usr/lib/check_mk_agent/plugins/3600/mk_docker_node:
  file.absent


/usr/lib/check_mk_agent/plugins/3600/mk_docker_piggyback:
  file.absent

python-pip:
  pkg.installed

docker:
  pip.installed:
    - require:
      - pkg: python-pip

/usr/lib/check_mk_agent/plugins/3600/mk_docker.py:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_docker.py
    - mode: 755
    - makedirs: True
    - dir_mode: 755
    - require: 
       - docker


{% endif %}

{% if salt['pillar.get']('check_mk_agent:plugins:logwatch') %}

/usr/lib/check_mk_agent/plugins/mk_logwatch:
  file.managed:
    - source: salt://check_mk_agent/files/plugins/mk_logwatch
    - mode: 755

/etc/check_mk/logwatch.cfg:
  file.managed:
    - source: salt://check_mk_agent/files/cfg/logwatch.jinja
    - mode: 644
    - template: jinja

{% endif %}