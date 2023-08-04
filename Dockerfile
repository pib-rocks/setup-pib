FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y curl sudo software-properties-common apt-utils
RUN apt install -y tzdata
RUN rm -rf /var/lib/apt/lists/*


RUN useradd --create-home --password=pib pib
RUN echo 'pib ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/pib
RUN usermod -aG sudo pib

USER pib
RUN sh -c 'id -a'
COPY --chown=pib:pib setup-pib.sh /home/pib
# setup-pib.sh uses sudo extensively. Unfortunanely without -E, which means that 
# e.g. DEBIAN_FRONTEND=noninteractive does not help to overcome tzdata.
# Thus we install tzdata earlier, where we have better control...

RUN env DEBIAN_FRONTEND=noninteractive bash -x /home/pib/setup-pib.sh

