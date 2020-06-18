FROM debian:unstable-20200607

# Packages
RUN apt-get update &&\
    apt-get install -y ca-certificates curl file g++ git locales make uuid-runtime strace \
                       procps \
                       tree \
                       vim \
                       git \
                       curl \
                       openssh-server \
                       yadm \
                       zsh \
                       git \
                       hey \
                       silversearcher-ag \
                       dnsutils \
                       iputils-clockdiff \
                       iputils-arping \
                       iputils-tracepath \
                       iputils-ping \
                       httpie \
                       python3-pip \
                       wget &&\
                       rm -rf /var/lib/apt/lists/*

# zsh
RUN zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" ||true
RUN ln -f /bin/zsh /bin/sh

# Configuration

# h2t
RUN git clone https://github.com/gildasio/h2t && cd h2t && pip3 install -r requirements.txt

# ssh
RUN mkdir /var/run/sshd /root/.ssh
RUN curl https://github.com/steinbrueckri.keys >> /root/.ssh/authorized_keys

# cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Final
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
