
MYSQL_PASSWORD = `DJANGO_SETTINGS_MODULE=settings python -c "from django.conf import settings; print settings.DATABASES['default']['PASSWORD']"`
MYSQL_USER = `DJANGO_SETTINGS_MODULE=settings python -c "from django.conf import settings; print settings.DATABASES['default']['USER']"`
MYSQL_DB = `DJANGO_SETTINGS_MODULE=settings python -c "from django.conf import settings; print settings.DATABASES['default']['NAME']"`
MYSQL_BACKUP = "backup-`date +%Y-%m-%d-%H-%M`.sql"

run:
	./manage.py runserver

setupenv:
	cp config/envvars ${VIRTUAL_ENV}/bin/postactivate

migrate:
	./manage.py migrate --noinput

test:
	./manage.py test

deps:
	pip install -r config/requirements/local.pip --exists-action=s
	npm install
	bower install

systemdeps:
	apt-get install -y postgresql libpq-dev python-dev supervisor nginx

clean:
	find . -name "*.pyc" -delete

dumpfixtures:
	./manage.py dumpdata --indent=2 core > core/fixtures/initial_data.json

messages:
	django-admin.py makemessages -l fr_FR

compilemessages:
	django-admin.py compilemessages

mysqlbackup:
	@mysqldump -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DB) > $(MYSQL_BACKUP)
	@gzip $(MYSQL_BACKUP)
	@echo "$(MYSQL_BACKUP).gz"

pylint:
	pylint --rcfile=config/pylintrc .

ctags:
	ctags -R --languages=python --python-kinds=-v ${VIRTUAL_ENV}/lib/python2.7
	ctags -R -a --languages=python --python-kinds=-v ${VIRTUAL_ENV}/src
	ctags -R -a --languages=python --python-kinds=-v .
