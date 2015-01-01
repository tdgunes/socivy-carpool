__author__ = 'tdgunes'

from socket import socket, SO_REUSEADDR, SOL_SOCKET
from asyncio import Task, coroutine, get_event_loop
import json, requests


class API(object):
    def __init__(self):
        self.url = "http://127.0.0.1:8000/api/v1/chat/"

    def start_room(self, received_json):
        """
        Starting a room that is
        received from asyncio based chat server
        {
           "sender": "tdgunes@gmail.com",
           "recipient": "hakanuyumaz@gmail.com"
        }
        Returns
        {
            status: {}
            room : 1
        }
        :param request:
        :return:
        """
        print("Sending to django: {0}".format(received_json))
        response = requests.post(self.url+"start_room/", data=json.dumps(received_json))
        return response.text

    def store_message(self, recieved_json):
        print("Sending to django: {0}".format(received_json))
        response = requests.post(self.url+"store_message/", data=json.dumps(received_json))
        return response.text

class Database(object):
    def __init__(self):
        self.rooms = {}

    def add_room(self, room):
        self.rooms[room.id] = room

    def remove_room(self, room_id):
        self.rooms.pop(room_id)

    def send_message(self, room, peer, message):
        """

        :type room: Room
        :type peer: Peer
        :type message: Message
        :return:
        """
        for peer in room.get_peers():
            pass






class Room(object):
    def __init__(self, id):
        self.id = id
        self.peers = []

    def get_peers(self):
        return self.peers


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
            print("Received message from peer: {0}".format(json.dumps(message, indent=4)))
            # message = {"sender":"tdgunes@gmail"}
            email = message["sender"]
            self._server.users[email] = self
            self.email = email
            api = API()
            if message["method"] == "room":
                self.send(api.start_room(message))
            elif method["method"] == "message":
                self.send(api.store_message(message))



            # self._server.broadcast('%s: %s' % (self.name, buf.decode('utf8')), peer=self)

