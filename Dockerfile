# This Dockerfile is an unfinished draught. See the TODOs below.
# (C) 2023 Juergen Weigert, distribute under GPLv2 or ask.
#
# References:
# - https://docs.docker.com/engine/reference/builder/
# - https://pib.rocks/build/how-to-install-a-digital-twin-of-pib/
#
#
# Build & publish instructions:
# - docker docker build . --tag=pibrocks/setup-pib:latest
# - docker login -u pibrocks
# - docker push pibrocks/setup-pib:latest #	-> https://hub.docker.com/repository/docker/pibrocks/setup-pib/tags?page=1&ordering=last_updated
#
# Usage instructions:
# - docker run --rm -ti pibrocks/setup-pib bash
#  -> look around, and finish the setup.

FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="juergen@fabmail.org"
LABEL version="0.1 wip"
LABEL description="A container with just enough PIP infrastructure to run the simulator"

# hex 0x50 = 'P', 0x52 = 'R'
EXPOSE 5052/tcp

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y curl sudo software-properties-common apt-utils php-fpm
# php-fpm
#   is required for cerebra
# curl
#   is (currently) required to download files from github (TODO: use COPY setup_files instead.)
# sudo
#   is required by setup-pib.sh (TODO: obsolete this, docker has root access internally)
# software-properties-common
#   provides apt-add-repository
# apt-utils
#   was mentioned as missing during package install (probably not really needed)
#
RUN apt install -y tzdata
RUN rm -rf /var/lib/apt/lists/*


RUN useradd --create-home --password=pib pib
RUN echo 'pib ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/pib
RUN usermod -aG sudo pib

# now the system has a user pib. Become pib.
USER pib
WORKDIR /home/pib
RUN sh -c 'id -a'
COPY --chown=pib:pib setup-pib.sh /home/pib
# setup-pib.sh uses sudo extensively. Unfortunanely without -E, which means that
# e.g. DEBIAN_FRONTEND=noninteractive does not help to overcome tzdata.
# Thus we install tzdata earlier, where we have better control...

RUN env DEBIAN_FRONTEND=noninteractive bash -e /home/pib/setup-pib.sh
RUN env DEBIAN_FRONTEND=noninteractive bash -e /home/pib/setup-digital-twin.sh


# The gazebo user interface needs a way to connect to the users's desktop
# This cannot work nicely with docker. Possible solutions:
# - hack from stackoverflow to make the user's Linux X11-Server reachable from docker (does not work with Windows)
# - run gazeboo outsde of docker, document how to connect.
# - run a full Linux Desktop including X-Server and novnc inside docker
# - For accessing the digital twin through the web, is it possible to use this?
#   https://github.com/gazebo-web/gzweb
#
# TODO: continue with one or more of this ideas.

CMD echo "WARNING: This is an unfinished draught."
CMD echo "See discussion on https://github.com/pib-rocks/setup-pib/pull/11"
CMD echo "----"
CMD echo "Finally, this container should start web UI, so that you can connect with your browser."

