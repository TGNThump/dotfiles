FROM ubuntu:bionic
RUN apt-get update -y && apt-get dist-upgrade -y
RUN apt-get install sudo dialog apt-utils locales -y
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN useradd -m ben -s /bin/bash
RUN echo 'ben ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/ben
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8
ENV TERM xterm-256color
WORKDIR /home/ben
RUN chown -R ben:ben .
USER ben
COPY ./install-dependencies.sh ./.dotfiles/
RUN bash ./.dotfiles/install-dependencies.sh
COPY . ./.dotfiles
RUN bash ./.dotfiles/install-dotfiles.sh