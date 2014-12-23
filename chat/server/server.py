__author__ = 'tdgunes'

from socket import socket, SO_REUSEADDR, SOL_SOCKET
from asyncio import Task, coroutine, get_event_loop
from .peer import Peer

class Server(object):
    PORT = 1234
    def __init__(self, loop):
        self.loop = loop
        self._serv_sock = socket()
        self._serv_sock.setblocking(0)
        self._serv_sock.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
        self._serv_sock.bind(('', Server.PORT))
        self._serv_sock.listen(5)
        self._peers = []
        self._users = {}
        Task(self._server())

    def remove(self, peer=""):
        self._peers.remove(peer)
        self.broadcast('Peer %s quit!\n')

    def broadcast(self, message , peer=None):
        if peer:
            print("[SERVER]:{1} sent: {0}".format(message, peer.name))
        for peer in self._peers:
            peer.send(message)

    @coroutine
    def _server(self):
        while True:
            peer_sock, peer_name = yield from self.loop.sock_accept(self._serv_sock)
            peer_sock.setblocking(0)
            peer = Peer(self, peer_sock, peer_name)
            self._peers.append(peer)
            self.broadcast('{"status":"connectionEstablished"}', peer)
