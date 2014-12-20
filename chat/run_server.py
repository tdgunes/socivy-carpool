__author__ = 'tdgunes'

from socket import socket, SO_REUSEADDR, SOL_SOCKET
from asyncio import Task, coroutine, get_event_loop

from server import Server

if __name__ == '__main__':
    port_number = 1234
    print("Server is started on port: {0}".format(port_number))
    loop = get_event_loop()
    Server(loop)
    loop.run_forever()
