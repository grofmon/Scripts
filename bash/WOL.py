#!/usr/bin/env python
import socket
s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto('\xff'*6+'\x01\x23\x45\x67\x89\x0a'*16, ('192.168.0.3', 80))
