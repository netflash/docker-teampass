FROM richarvey/nginx-php-fpm:latest

ENV path /app
ENV version 2.1.25.0
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing && apt-get upgrade -y
# https://github.com/nilsteampassnet/TeamPass/issues/801
RUN apt-get install -y vim git php5-mysqlnd && \
apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean
RUN git clone https://github.com/nilsteampassnet/TeamPass.git ${path}
RUN cd ${path} && git checkout $version
RUN chmod 777 ${path}/install/ ${path}/includes/ ${path}/files/ ${path}/upload/ ${path}/includes/avatars && \
chown www-data:www-data -R /app
RUN sed -i -e 's/root \/usr\/share\/nginx\/html/root \/app/g' /etc/nginx/sites-enabled/default.conf
RUN sed -i -e 's/max_execution_time = 30/max_execution_time = 60/g' /etc/php5/fpm/php.ini
RUN php5enmod mcrypt
ADD ./start_teampass.sh /start_teampass.sh
RUN chmod 755 /start_teampass.sh

EXPOSE 80
CMD [ "/bin/bash", "/start_teampass.sh" ]
