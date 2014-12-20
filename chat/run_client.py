__author__ = 'tdgunes'


from client import Client

if __name__ == '__main__':
    client = Client()

if __name__ == '__main__':
    port_number = 1234
    print("Server is started on port: {0}".format(port_number))
    loop = get_event_loop()
    Server(loop, port_number)
    loop.run_forever()
