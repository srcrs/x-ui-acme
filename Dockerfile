FROM ubuntu:latest
RUN apt-get update \
    && apt-get install curl -y \
    && apt-get install wget -y \
    && apt-get install systemd -y \
    && apt-get install systemctl -y \
    && wget -O /bin/install.sh https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh \
    && chmod +x /bin/install.sh \
    && bash /bin/install.sh
