__author__ = 'tdgunes'

from socket import socket, SO_REUSEADDR, SOL_SOCKET
from asyncio import Task, coroutine, get_event_loop
from .peer import Peer, API


class Room(object):
    def __init__(self, identifier):
        """

        :type identifier: int
        :param identifier:
        :return:
        """
        self.identifier = identifier
        self.peers = []

    def send(self, message):
        for peer in self.peers:
            peer.send(message)

    def add_member(self, peer):
        self.peers.append(peer)


class Rooms(object):
    def __init__(self):
        # identifier:Int -> room:Room
        self.rooms = {}

    def get_room(self, identifier):
        room = self.rooms[identifier]
        return room

    def add_room(self, identifier):
        """
        :type identifier
        :param identifier:
        :return:
        """
        if not self.rooms.get(identifier):
            self.rooms[identifier] = Room(identifier)
        return self.rooms[identifier]

    def remove_room(self, identifier):
        """
        :type identifier
        :param identifier:
        :return:
        """
        self.rooms.pop(identifier)

    def send(self, identifier, message):
        room = self.rooms[identifier]
        room.send(message)

    def add_member(self, identifier, member):
        room = self.rooms[identifier]
        room.add_member(member)


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

        Task(self._server())

        self.rooms = Rooms()
        self.users = {}


    def remove(self, peer=""):
        self._peers.remove(peer)
        self.broadcast('Peer %s quit!\n')

    def broadcast(self, message, peer=None):
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
            peer.send('{"status":"connectionEstablished"}')
            self._peers.append(peer)
