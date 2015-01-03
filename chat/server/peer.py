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
        # print("Sending to django: {0}".format(received_json))
        response = requests.post(self.url+"start_room/", data=json.dumps(received_json))
        return response.text

    def store_message(self, recieved_json):
        # print("Sending to django: {0}".format(received_json))
        response = requests.post(self.url+"store_message/", data=json.dumps(received_json))
        return response.text




class Peer(object):
    def __init__(self, server, sock, name):
        self.loop = server.loop
        self.name = name # socketName
        self._sock = sock
        self._server = server

        self.chat_email = ""
        self.chat_name = ""

        Task(self._peer_handler())

    def send(self, data):
        print("sending {1} to peer {0} ".format(self.name, data))
        data = data + "\n"
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
            print(buf.decode('utf8'))
            if buf == b'':
                break
            print("Server got '{0}' ".format(buf.decode('utf8')))


            message_as_string = buf.decode('utf8').strip()
            message = json.loads(message_as_string)
            self.chat_email = message["peer"]["email"]
            self.chat_name = message["peer"]["name"]

            api = API()
            if message["method"] == "acknowledge":
                self.chat_email = message["peer"]["email"]
                self.chat_name = message["peer"]["name"]

                print("New user connected with:\n{0}: {1}".format(self.chat_email, self.chat_name))
                self._server.users[self.chat_email] = self

            elif message["method"] == "room":
                room_creation_as_string = api.start_room(message)
                room_creation_as_json = json.loads(room_creation_as_string)

                room = self._server.rooms.add_room(room_creation_as_json["room"])



                recipient = self._server.users.get(room_creation_as_json["recipient"]["peer"]["email"],None)

                if recipient:
                    room_creation_as_json["peer"] = room_creation_as_json["sender"]["peer"]
                    recipient.send(json.dumps(room_creation_as_json))

                room_creation_as_json["peer"] = room_creation_as_json["recipient"]["peer"]

                room.add_member(recipient)
                room.add_member(self)

                self.send(json.dumps(room_creation_as_json))

            elif message["method"] == "message":
                # api.store_message(message)

                room = self._server.rooms.get_room(message["room"])

                for peer in room.peers:
                    if peer.chat_email != self.chat_email:
                        peer.send(message_as_string)


