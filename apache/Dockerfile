ARG APACHE_VERSION=""
FROM httpd:${APACHE_VERSION:+${APACHE_VERSION}-}alpine

RUN apk update; \
    apk upgrade;

# Copy apache vhost file to proxy php requests to php-fpm container
COPY limesurvey.conf /usr/local/apache2/conf/limesurvey.conf
RUN echo "Include /usr/local/apache2/conf/limesurvey.conf" \
    >> /usr/local/apache2/conf/httpd.conf

# RUN mkdir -p /var/www/html
# RUN chmod -R 755 /var/www/html/
# RUN chown -R www-data:www-data /var/www/html/