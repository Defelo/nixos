#!/usr/bin/python

import socket
import os

s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
s.connect(f"/run/user/{os.getuid()}/yubikey-touch-detector.socket")


def update(touch):
    print(""*touch, flush=True)
    os.system(f"polybar-msg action yk module_{['hide','show'][touch]} > /dev/null")

update(False)
while True:
    update(s.recv(5).decode().endswith("1"))
