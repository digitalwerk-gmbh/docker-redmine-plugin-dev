FROM rails4

RUN svn --non-interactive --trust-server-cert co https://svn.redmine.org/redmine/branches/3.4-stable /opt/redmine-3.4
RUN ln -s /opt/redmine-3.4 /opt/redmine

WORKDIR /opt/redmine


RUN echo "production:" > config/database.yml
RUN echo "  adapter: sqlite3" >> config/database.yml
RUN echo "  database: db/production.sqlite3" >> config/database.yml

RUN echo "development:" >> config/database.yml
RUN echo "  adapter: sqlite3" >> config/database.yml
RUN echo "  database: db/development.sqlite3" >> config/database.yml

RUN echo "test:" >> config/database.yml
RUN echo "  adapter: sqlite3" >> config/database.yml
RUN echo "  database: db/test.sqlite3" >> config/database.yml

RUN bundle install
RUN rake db:migrate RAILS_ENV=production
RUN rake generate_secret_token RAILS_ENV=production
RUN rake db:migrate RAILS_ENV=development
RUN rake generate_secret_token RAILS_ENV=development
RUN rake db:migrate RAILS_ENV=test
RUN rake generate_secret_token RAILS_ENV=test

RUN rm plugins/README

RUN echo "#!/bin/bash" > /bin/redmine-test
RUN echo "export RAILS_ENV=test" >> /bin/redmine-test
RUN echo "bundle install" >> /bin/redmine-test
RUN echo "rake redmine:plugins:migrate" >> /bin/redmine-test
RUN echo 'if [ "$1" == "plugins" ] ; then' >> /bin/redmine-test
RUN echo "    rake redmine:plugins:test" >> /bin/redmine-test
RUN echo "else" >> /bin/redmine-test
RUN echo "    rake redmine:test" >> /bin/redmine-test
RUN echo "fi" >> /bin/redmine-test
RUN chmod +x /bin/redmine-test

RUN echo "#!/bin/bash" > /bin/redmine
RUN echo 'export RAILS_ENV=$1' >> /bin/redmine
RUN echo "bundle install" >> /bin/redmine
RUN echo "rake redmine:plugins:migrate" >> /bin/redmine
RUN echo "rails server --binding=*" >> /bin/redmine
RUN chmod +x /bin/redmine

EXPOSE 3000
VOLUME [ "/opt/redmine/plugins" ]
