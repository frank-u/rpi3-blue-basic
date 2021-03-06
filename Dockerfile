FROM resin/raspberrypi3-debian:jessie

ENV INITSYSTEM on

WORKDIR /usr/src/app

# Add the key for foundation repository
RUN apt-get update && apt-get install -y wget
RUN wget http://archive.raspberrypi.org/debian/raspberrypi.gpg.key -O - | sudo apt-key add -

# Add apt source of the foundation repository
# We need this source because bluez needs to be patched in order to work with rpi3
# (Issue #1314: How to get BT working on Pi3B. by clivem in raspberrypi/linux on GitHub)
# Add it on top so apt will pick up packages from there
RUN sed -i '1s#^#deb http://archive.raspberrypi.org/debian jessie main\n#' /etc/apt/sources.list

# Install dependencies and then clean up
RUN apt-get update && apt-get install -y \
  bluetooth \
  bluez \
  bluez-firmware && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy files over
COPY . ./

# Start app
CMD ["bash", "start.sh"]