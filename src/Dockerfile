FROM debian:unstable-20210326
LABEL maintainer="richard.steinbrueck@googlemail.com"

## Configuration ##############################################################
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

## Init #######################################################################
COPY src/supervisord/supervisord-sshd.conf /etc/supervisor/conf.d/sshd.conf
COPY src/supervisord/supervisord-nginx.conf /etc/supervisor/conf.d/nginx.conf
COPY src/supervisord/supervisord.conf /etc/

# Runtime config ##############################################################
COPY src/entrypoint.sh /entrypoint.sh
COPY src/entrypoint.d /dev/entrypoint.d
RUN chmod 755 /entrypoint.sh

# Packages ####################################################################
COPY src/packages.txt /tmp/packages.txt
# I use cat because i like cat!
# hadolint ignore=DL3008,DL3009,DL3015,SC2002,SC2046
RUN apt-get update && apt-get -q -y -o Dpkg::Use-Pty=0 install $(cat /tmp/packages.txt) && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# oh-my-zsh ###################################################################
RUN zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

# Static binarys ##############################################################
## Kafkactl - https://github.com/deviceinsight/kafkactl/
WORKDIR /tmp/kafkactl
RUN curl -L https://github.com/deviceinsight/kafkactl/releases/download/v1.14.0/kafkactl_1.14.0_Linux_x86_64.tar.gz --output kafkactl.tar.gz &&\
    tar xvfz kafkactl.tar.gz &&\
    cp /tmp/kafkactl/kafkactl /usr/local/bin/kafkactl &&\
    chmod +x /usr/local/bin/kafkactl

# setup nginx #################################################################
RUN rm /var/www/html/*
COPY src/html/* /var/www/html/
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# setup ssh ###################################################################
RUN mkdir /var/run/sshd /root/.ssh

# Final #######################################################################
EXPOSE 22 80
WORKDIR /
CMD ["/entrypoint.sh"]
