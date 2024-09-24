#!/usr/bin/env bash

# https://tigervnc.org/doc/vncpasswd.html

rm -Rf /tmp/.X1-lock

vncserver :1 && \
vncserver -list && \
websockify --web=/usr/share/novnc/ 6080 localhost:5901
