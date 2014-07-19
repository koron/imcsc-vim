# vim:fileencoding=utf-8

import os
import socket
import struct

FCITX_STATUS = struct.pack('i', 0)
FCITX_OPEN = struct.pack('i', 1 | (1 << 16))
FCITX_CLOSE = struct.pack('i', 1)

INT_SIZE = struct.calcsize('i')


# Determine fcitx's socket file.
def fcitx_socket_file():
    path = '/tmp/fcitx-socket-' + os.environ['DISPLAY']
    if not os.access(path, os.W_OK):
        idx = path.rindex('.')
        if idx >= 0:
            path = path[0:idx]
        else:
            path += '.0'
    if not os.access(path, os.W_OK):
        raise Exception("can't open fcitx socket file.")
    return path


# Send a message to fcitx.
def fcitx_send(send_data, recv_size=0):
    sock = socket.socket(socket.AF_UNIX)
    sock.connect(fcitx_socket_file())
    try:
        sock.send(send_data)
        if recv_size > 0:
            return sock.recv(INT_SIZE)
        else:
            return []
    finally:
        sock.close()


# Get fcitx status
def fcitx_is_active():
    recv = fcitx_send(FCITX_STATUS, INT_SIZE)
    if struct.unpack('i', recv)[0] == 2:
        return True
    else:
        return False


# Make fcitx active.
def fcitx_active():
    fcitx_send(FCITX_OPEN)


# Make fcitx inactive.
def fcitx_inactive():
    fcitx_send(FCITX_CLOSE)


if __name__ == '__main__':
    import sys

    def get_mode():
        if len(sys.argv) < 2:
            return -1
        v = int(sys.argv[1])
        if v != 0:
            return 1
        else:
            return 0

    mode = get_mode()
    if mode == 1:
        fcitx_active()
    elif mode == 0:
        fcitx_inactive()
    else:
        print(fcitx_is_active())