FROM ubuntu:20.04
USER root
ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]
RUN apt update \
    && apt upgrade -y \
    && apt install -y apt-utils software-properties-common \
    && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && apt-get install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt install -y nano build-essential git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev mariadb-server mariadb-client \
    && curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash \
    && echo '#!/bin/bash' > /root/rbenv.env \
    && echo 'export PATH="/root/.rbenv/bin:${PATH}"' >> /root/rbenv.env \
    && echo 'eval "$(rbenv init -)"' >> /root/rbenv.env \
    && echo 'source /root/rbenv.env' >> /root/.bashrc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN source /root/rbenv.env \
    && rbenv install 2.7.1 \
    && rbenv global 2.7.1

RUN service mysql start \
    && mysql -e "DROP USER IF EXISTS ''" \
    && mysql -e "DROP DATABASE IF EXISTS test" \
    && mysql -e "FLUSH PRIVILEGES"


RUN apt-get update \
    && apt-get install -y supervisor libmariadb-dev \
    && mkdir -p /var/log/supervisor

WORKDIR /
RUN git clone https://github.com/frcteam195/cheesy-parts.git \
    && cd cheesy-parts \
    && source /root/rbenv.env \
    && bundle install \
    && touch /Pathfile

COPY config.json /cheesy-parts/config.json

WORKDIR /cheesy-parts
RUN source /root/rbenv.env \
    && service mysql start \
    && mysql -e "CREATE DATABASE cheesy_parts" \
    && bundle exec rake db:migrate

RUN mkdir /tools

ARG NOW

COPY start_script.sh /tools/start_script.sh

RUN chmod +x /tools/start_script.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9000

RUN mkdir -p /var/lib/mysql_initial \
    && cp -R /var/lib/mysql/. /var/lib/mysql_initial

CMD ["/usr/bin/supervisord"]

