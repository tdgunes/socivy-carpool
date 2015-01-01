from django.shortcuts import render
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.core import serializers
from django.http import HttpResponse
from django.utils import timezone
from . import APIResponseFactory, Status
import json  # TODO: validate received json on all views
from .models import Message, Peer, Room

# methods for iPhone

@csrf_exempt
@require_http_methods(["POST"])
def get_rooms_by_email(request):
    """
    This is called from iOS to get
    rooms that is related to the provided
    email
    Also add this email to Peer model, return the id of the mail
    received JSON:
    {
        "email":"tdgunes@gmail.com"
    }
    :param request: available
    :return:
    """
    data = json.loads(request.body.decode("utf-8"))

    try:
        peer = Peer.objects.get(email=data["email"])

        response = []
        for room in peer.rooms.all():
            room_obj = {"room": room.id, "contacts": []}
            for contact in room.contacts:
                room_obj["contacts"].append(contact.name)
            response.append(room_obj)

        return HttpResponse(APIResponseFactory.create(Status.Success, additions={"rooms": response}),
                            content_type='application/json')
    except Peer.DoesNotExist:
        Peer.objects.create(email=data["email"])
        return HttpResponse(APIResponseFactory.create(Status.Success, additions={"rooms": []}),
                            content_type='application/json')


@csrf_exempt
@require_http_methods(["GET", "POST"])
def get_all_chat_users(request):
    """
    Returns all peers and their ids, exclude senders email
    :param request:
    :return:
    """
    data = json.loads(request.body.decode("utf-8"))

    try:
        peer = Peer.objects.get(email=data["email"])
    except Peer.DoesNotExist:
        Peer.objects.create(email=data["email"])

    response = []
    for peer in Peer.objects.all():
        if peer.email != data["email"]:
            peer_obj = {"email": peer.email, "name": peer.name}
            response.append(peer_obj)

    return HttpResponse(APIResponseFactory.create(Status.Success, additions={"peers": response}),
                        content_type='application/json')


@csrf_exempt
@require_http_methods(["POST"])
def start_room(request):
    """
    Starting a room that is
    received from asyncio based chat server
    {
       "sender": "tdgunes@gmail.com",
       "recipient": "hakanuyumaz@gmail.com"
    }

    :param request:
    :return:
    """
    print(request.body)
    data = json.loads(request.body.decode("utf-8"))
    sender = Peer.objects.get(email=data["sender"])
    recipient = Peer.objects.get(email=data["recipient"])

    room = Room.objects.create()
    room.save()
    room.contacts.add(sender)
    room.contacts.add(recipient)
    sender.rooms.add(room)
    recipient.rooms.add(room)

    return HttpResponse(APIResponseFactory.create(Status.Success, additions={"peer": {"email": recipient.email,
                                                                                      "name": recipient.name},
                                                                             "text": "Chat room is started!",
                                                                             "timestamp": 123123123123,
                                                                             "room": room.id}),
                        content_type='application/json')


# asyncio chat server methods

@csrf_exempt
@require_http_methods(["POST"])
def store_message(request):
    """
    This is for storing message that is
    received from asyncio based chat server

    Received POST JSON:
    {
        "room" : 1,
        "sender" : "tdgunes@gmail.com",
        "text": "hello"
        //timestamp is not required, it will be automatically
                                     added while storing
    }
    :param request:
    :return:
    """
    data = json.loads(request.body.decode("utf-8"))

    try:
        room = Room.objects.get(id=data["room"])

        sender = Peer.objects.get(email=data["sender"])
        text = data["text"]

        message = Message.objects.create(sender=sender, text=text)
        message.save()
        room.messages.add(message)
        return HttpResponse(APIResponseFactory.create(Status.Success), content_type='application/json')
    except Room.DoesNotExist:
        return HttpResponse(APIResponseFactory.create(Status.Error, message="Raised Room.DoesNotExist exception"),
                            content_type='application/json')
    except Peer.DoesNotExist:
        return HttpResponse(APIResponseFactory.create(Status.Error, message="Raised Peer.DoesNotExist exception"),
                            content_type='application/json')


# ---

@csrf_exempt
@require_http_methods(["POST"])
def get_room_conversation(request):
    """
    This is called from iOS to get all messages
    of the room by room id
    :param request:
    :return:
    Received POST JSON:
    {
        "room" : 1
    }
    Sent JSON:
    [
        messageObject,
        ...
    ]
    """
    data = json.loads(request.body.decode("utf-8"))

    room = Room.objects.get(id=data["room"])
    response = []

    for message in room.messages.all():
        message_obj = {"text": message.text,
                       "sender": message.sender.email,
                       "timestamp": message.timestamp.replace(tzinfo=timezone.utc).timestamp()}
        response.append(message_obj)

    return HttpResponse(APIResponseFactory.create(Status.Success, additions={"messages": response}),
                        content_type='application/json')


