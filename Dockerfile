FROM debian:unstable-20200224

# Packages
RUN apt-get update &&\
    apt-get install -y strace \
                       procps \
                       tree \
                       vim \
                       git \
                       curl \
                       openssh-server \
                       yadm \
                       zsh \
                       silversearcher-ag \
                       dnsutils \
                       iputils-clockdiff \
                       iputils-arping \
                       iputils-tracepath \
                       iputils-ping \
                       httpie \
                       wget &&\
    rm -rf /var/lib/apt/lists/*

# Configuration
RUN mkdir /var/run/sshd /root/.ssh
RUN curl https://github.com/steinbrueckri.keys >> /root/.ssh/authorized_keys

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Final
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
