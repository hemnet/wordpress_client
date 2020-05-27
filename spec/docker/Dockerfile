FROM appcontainers/wordpress

# Copy the WP-Config file
RUN cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# White list custom metadata fields
RUN echo "register_meta('post', 'foo', array('type' => 'integer', 'description' => 'Some kind of integer', 'single' => true, 'show_in_rest' => true));" >>/var/www/html/wordpress/wp-config.php
RUN echo "register_meta('post', 'bar', array('type' => 'boolean', 'description' => 'Some kind of boolean', 'single' => true, 'show_in_rest' => true));" >>/var/www/html/wordpress/wp-config.php
RUN echo "register_meta('post', 'baz', array('type' => 'string', 'description' => 'Some kind of string', 'single' => true, 'show_in_rest' => true));" >>/var/www/html/wordpress/wp-config.php

# base image only contains American timezones
RUN yum install -y tzdata

ENV APP_NAME testapp.com
ENV APACHE_SVRALIAS www.testapp.com localhost
ENV MYSQL_SERVER localhost
ENV MYSQL_CLIENT localhost
ENV MYSQL_PASS P@ssw0rd
ENV MYSQL_DB testapp
ENV APP_USER admin
ENV APP_PASS P@ssw0rd
ENV WP_KEY ILoveFlappyjacks

# Make pretty permalinks work so API is accessible
COPY htaccess /var/www/html/wordpress/.htaccess

# Restore a copy of a set up database on first boot
COPY dbdump.sql.gz /tmp/dbdump.sql.gz
COPY restore-dbdump.sh /tmp/.restore-dbdump.sh
RUN chmod +x /tmp/.restore-dbdump.sh && \
    echo "if [ -f /tmp/.restore-dbdump.sh ]; then /tmp/.restore-dbdump.sh; rm -rf /tmp/.restore-dbdump.sh; fi" >> /root/.bashrc

### Install Basic Auth plugin
# Required for API to be able to make changes

# We need tar to unpack the WP plugins
RUN yum install -y tar

# Basic Auth
# Get download link from GitHub or something.
RUN curl -SL https://github.com/WP-API/Basic-Auth/archive/master.tar.gz \
  | tar -xzC /var/www/html/wordpress/wp-content/plugins/ \
  && mv /var/www/html/wordpress/wp-content/plugins/Basic-Auth* /var/www/html/wordpress/wp-content/plugins/basic-auth

# The appcontainer will run apache in the foreground after running their setup
# script. The setup script will unset all the env variables with passwords and
# other important information so they aren't exposed to the foregrounded apache
# process, so for this reason we cannot just append our DB restore to that
# script.
# The container used to just run bash, and by switching back to that we get
# everything working again.
CMD /bin/bash
