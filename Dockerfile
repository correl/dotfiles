FROM ubuntu

RUN apt-get update \
    && apt-get install -y sudo locales

RUN localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && useradd -m -s /bin/bash correl \
    && echo 'correl ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER correl
WORKDIR /home/correl
COPY . /home/correl/dotfiles
RUN DEBUG=1 /home/correl/dotfiles/provision.sh
CMD ["/usr/bin/zsh"]
