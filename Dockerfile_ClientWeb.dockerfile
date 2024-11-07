# Use Debian 11 (Bullseye) as the base image
FROM debian:11

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages, Netdata, Node.js, and Angular CLI
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    systemd \
    p7zip-full \
    gnupg \
    net-tools \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @angular/cli \
    && curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh \
    && sh /tmp/netdata-kickstart.sh \
    && sudo service netdata start \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the directory to store the downloaded file
RUN mkdir -p /app

# Download the .7z file containing the Angular app
RUN curl -L -o /app/AngularSimulatorClient.7z \
    https://github.com/Ben290402/BFF-POC/raw/a6557d7710dbf7b925b6d3824957cfad6a689a21/AngularSimulatorClient.7z

# Check if the .7z file exists and decompress it
RUN ls -l /app && 7z x /app/AngularSimulatorClient.7z -o/app && ls /app/AngularSimulatorClient

# Create directory for SSH service and other actions
RUN mkdir /var/run/sshd

# Expose the necessary ports for Netdata, the Angular app, and SSH
EXPOSE 19999 80 22

# Start Netdata, SSH, and the Angular app with ng serve
CMD ["/bin/bash", "-c", "service netdata start && /usr/sbin/sshd -D & cd /app/AngularSimulatorClient && ng serve --host 0.0.0.0 --port 80"]

