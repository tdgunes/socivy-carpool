__author__ = 'tdgunes'

from socket import socket, SOCK_STREAM, AF_INET
from threading import Thread
import json, time


class Client:
    HOST = 'localhost'
    PORT = 1234

    def __init__(self):
        self.s = socket(AF_INET, SOCK_STREAM)
        self.s.connect((Client.HOST, Client.PORT))
        self.start_listening()
        self.start_message_loop()

    def start_listening(self):
        t = Thread(target=self.listener)
        t.start()


    def listener(self):
        try:
            while True:
                data = self.s.recv(1024).decode('utf-8')
                print('', data)
        except ConnectionAbortedError:
            print("Connection is aborted!")
            pass

    def acknowledge(self):
        message = {"peer": {"email": "deniz.sokmen@ozu.edu.tr", "name": "deniz.sokmen@ozu.edu.tr"},
                   "method": "acknowledge"}
        self.send(message)

    def start_room(self):
        message = {"peer": {"email": "deniz.sokmen@ozu.edu.tr", "name": "deniz.sokmen@ozu.edu.tr"},
                   "recipient": "taha.gunes@ozu.edu.tr", "method": "room"}
        self.send(message)

    def send_message(self, message, room_id):
        message = {"peer": {"email": "deniz.sokmen@ozu.edu.tr", "name": "deniz.sokmen@ozu.edu.tr"}, "text":message, "room": room_id, "timestamp":1231231,
                   "method": "message"}
        self.send(message)

    def send(self, message):
        self.s.send((json.dumps(message) + "\n").encode('utf-8'))

    def start_message_loop(self):
        try:
            self.acknowledge()
            time.sleep(2)
            self.start_room()
            room_id = int(input("Room id:"))
            # t = """{"status":{"message": "Success!", "code": 1}, "room": 87, "timestamp": 123123123123, "peer": {"name": "Hakan Uyumaz", "email": "hakanuyuma@gmail.com"}, "text": "Chat room is started!"}"""
            # self.s.send(t.encode('utf-8'))
            print("Ready for messaging!")
            while True:
                message = input('')
                self.send_message(message, room_id)
        except EOFError:
            pass
        finally:
            self.s.close()

