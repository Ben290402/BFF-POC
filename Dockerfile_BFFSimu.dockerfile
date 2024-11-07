# Use Debian 11 (Bullseye) as the base image
FROM debian:11

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and Netdata
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    systemd \
    && curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh \
    && sh /tmp/netdata-kickstart.sh \
    && sudo service netdata start \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git \
    && unzip

# Créer un répertoire pour le service SSH
RUN mkdir /var/run/sshd \
    && curl -L -o /path/in/container/ https://github.com/Ben290402/BFF-POC/blob/a6557d7710dbf7b925b6d3824957cfad6a689a21/BFFSimulatorAPI.7z

# Expose the default Netdata port
EXPOSE 19999 80 22

# Start Netdata
CMD ["netdata", "/usr/sbin/sshd", "-D"]
