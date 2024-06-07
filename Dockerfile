FROM node:19.1.0

LABEL org.opencontainers.image.authors="Benjamin Féron"

ARG USER=mapscii

RUN apt-get update -y \
  && apt install -y \
    sudo \
    systemctl \
    telnetd \
  && apt-get clean

RUN adduser -gecos --disabled-password --shell /bin/rbash $USER

RUN echo "telnetd ALL = NOPASSWD: /bin/login" > /etc/sudoers.d/telnetd

RUN echo "#!/bin/sh\n" \
  "sudo /bin/login -f $USER" \
  > /usr/local/bin/autologin \
  && chmod +x /usr/local/bin/autologin

RUN echo "telnet stream tcp nowait telnetd /usr/sbin/tcpd /usr/sbin/in.telnetd -L /usr/local/bin/autologin" > /etc/inetd.conf

RUN echo "" \
  > /etc/issue.net \
  && touch /home/$USER/.hushlogin

RUN npm install --global mapscii

RUN echo "\n" \
  "\n" \
  "\n" \
  "                • ▌ ▄ ·.  ▄▄▄·  ▄▄▄·.▄▄ ·  ▄▄· ▪  ▪  \n" \
  "                ·██ ▐███▪▐█ ▀█ ▐█ ▄█▐█ ▀. ▐█ ▌▪██ ██ \n" \
  "                ▐█ ▌▐▌▐█·▄█▀▀█  ██▀·▄▀▀▀█▄██ ▄▄▐█·▐█·\n" \
  "                ██ ██▌▐█▌▐█ ▪▐▌▐█▪·•▐█▄▪▐█▐███▌▐█▌▐█▌\n" \
  "                ▀▀  █▪▀▀▀ ▀  ▀ .▀    ▀▀▀▀ ·▀▀▀ ▀▀▀▀▀▀\n" \
  "\n" \
  "              MapSCII - The whole world in your console.\n" \
  "\n" \
  "                           made with <3 at\n" \
  "                    https://github.com/rastapasta\n" \
  "\n" \
  "                map data © OpenStreetMap contributors\n" \
  "\n" \
  "                                 ---\n" \
  "\n" \
  "                        dockerized with <3 at\n" \
  "                    https://github.com/benjamin-feron" \
  "\n" \
  > /mapscii-banner

RUN echo "mapscii; cat /mapscii-banner; exit" \
  > /home/$USER/.bashrc

RUN chmod -w /home/$USER/.* && chmod +w /home/$USER

EXPOSE 23

CMD systemctl start inetd; while [ true ]; do sleep 60; done
