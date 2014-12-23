__author__ = 'tdgunes'

from socket import socket, SO_REUSEADDR, SOL_SOCKET
from asyncio import Task, coroutine, get_event_loop
import json, requests

class Room(object):
    def __init__(self, id):
        self.identifier = id
        self.peers = []


class Peer(object):
    def __init__(self, server, sock, name):
        self.loop = server.loop
        self.name = name
        self._sock = sock
        self._server = server
        self.email = ""
        Task(self._peer_handler())

    def send(self, data):
        return self.loop.sock_sendall(self._sock, data.encode('utf8'))

    @coroutine
    def _peer_handler(self):
        try:
            yield from self._peer_loop()
        except IOError:
            pass
        finally:
            self._server.remove(self)

    @coroutine
    def _peer_loop(self):
        while True:
            buf = yield from self.loop.sock_recv(self._sock, 1024)
            if buf == b'':
                break

            message = json.loads(buf.decode('utf8'))
            # message = {"email":"tdgunes@gmail"}

            self._server.users[message["email"]] = peer


            # self._server.broadcast('%s: %s' % (self.name, buf.decode('utf8')), peer=self)

