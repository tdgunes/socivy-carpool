__author__ = 'tdgunes'

from socket import socket, SOCK_STREAM, AF_INET
from threading import Thread


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

    def start_message_loop(self):
        try:
            while True:
                message = input('')
                self.s.send(message.encode('utf-8'))
        except EOFError:
            pass
        finally:
            self.s.close()

