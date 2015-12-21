FROM richarvey/nginx-php-fpm:stable

ENV path /app
ENV version 2.1.24

RUN apt-get update --fix-missing
RUN apt-get install -y vim git
RUN git clone https://github.com/nilsteampassnet/TeamPass.git ${path}
RUN cd ${path} && git checkout $version
RUN chmod 777 ${path}/install/ ${path}/includes/ ${path}/files/ ${path}/upload/
RUN sed -i -e 's/root \/usr\/share\/nginx\/html/root \/app/g' /etc/nginx/sites-enabled/default.conf
RUN sed -i -e 's/max_execution_time = 30/max_execution_time = 60/g' /etc/php5/fpm/php.ini
RUN php5enmod mcrypt

EXPOSE 80

