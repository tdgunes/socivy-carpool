from django.test import TestCase
from .models import Peer
from . import APIResponseFactory, Status
import json


class APITestCases(TestCase):

    @staticmethod
    def get_relative_url(first_url):
        return "/".join(first_url.split("/")[-2:])

    def send_post(self, data, url):
        response = self.client.post(url, json.dumps(data), "application/json",
                                    HTTP_X_REQUESTED_WITH='XMLHttpRequest').content.decode("utf-8")
        print("Res: {0}".format(url))
        response = json.loads(response)
        print(json.dumps(response, indent=4),end=" = ")
        print(response["status"]["code"])
        return response

    def setUp(self):
        omer = Peer.objects.create(email="kalaomer@hotmail.com", name="Omer Kala")
        hakan = Peer.objects.create(email="hakanuyumaz@gmail.com", name="Hasan Uyumaz")


    def test_get_rooms_by_email(self):
        alex_email = "alex@tdgunes.org"
        data = dict(email=alex_email)
        response = self.send_post(data, "/api/v1/chat/get_rooms_by_email/")

        self.assertEqual(response["status"]["code"], Status.Success)

        alex = Peer.objects.get(email=alex_email)
        self.assertNotEqual(alex,None)

    def test_get_all_chat_users(self):
        response = self.send_post({"email":"kalaomer@hotmail.com"}, "/api/v1/chat/get_all_chat_users/")
        self.assertEqual(response["status"]["code"], Status.Success)
        self.assertEqual(response["peers"][0]["email"],"hakanuyumaz@gmail.com")

    def test_start_room(self):
        response = self.send_post({"sender":"hakanuyumaz@gmail.com", "recipient":"kalaomer@hotmail.com"}, "/api/v1/chat/start_room/")
        self.assertEqual(response["status"]["code"], Status.Success)
        self.assertEqual(response["room"], 1)

    def test_store_message(self):
        self.test_start_room() # writing in one
        response = self.send_post({"sender":"hakanuyumaz@gmail.com", "room":1, "text":"naber"}, "/api/v1/chat/store_message/")
        response = self.send_post({"sender":"kalaomer@hotmail.com", "room":1, "text":"iyidir sendne"}, "/api/v1/chat/store_message/")
        self.assertEqual(response["status"]["code"],Status.Success)

    def test_get_room_conversation(self):
        self.test_store_message()
        response = self.send_post({"sender":"hakanuyumaz@gmail.com", "room":1, "text":"naber"}, "/api/v1/chat/get_room_conversation/")
