FROM ubuntu:17.10
# tu = test user

ARG DRYRUN=${DRYRUN}
ARG QUIET=${QUIET}
RUN apt update && \
    if [ $QUIET ]; then QUIETFLAG="-qq"; fi && \
    apt -y $QUIETFLAG install sudo curl && \
    echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
    useradd tu -d /home/tu -p '' -s /bin/bash && \
    usermod -aG sudo tu && \
    mkdir /home/tu && \
    chown -R tu:tu /home/tu
ADD . /home/tu/dotfiles
USER tu
WORKDIR /home/tu
RUN sudo chown -R tu:tu /home/tu/dotfiles && \
    sudo sync && \
    ./dotfiles/bin/dflocal all

