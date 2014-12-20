from django.shortcuts import render
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.core import serializers
from django.http import HttpResponse

import json  # TODO: validate received json on all views
from .models import Message, Peer, Room

# methods for iPhone

@csrf_exempt
@require_http_methods(["POST"])
def start_room(request):
    """
    Starting a room with two peer id
    sender vs recipient
    :param request:
    :return:
    """
    data = json.loads(request.body.decode("utf-8"))
    sender = Peer.objects.get(id=data["sender"])
    recipient = Peer.objects.get(id=data["recipient"])
    room = Room.objects.create()
    room.contacts.add(sender)
    room.contacts.add(recipient)

    sender.rooms.add(room)
    recipient.rooms.add(recipient)

    response = json.dumps({"room": room.id})
    return HttpResponse(response,  content_type='application/json')


@csrf_exempt
@require_http_methods(["GET", "POST"])
def get_all_chat_users(request):
    """
    Returns all peers and their ids
    :param request:
    :return:
    """
    response = []

    for peer in Peer.objects.all():
        peer_obj = {"email": peer.email, "id": peer.id, "name":peer.name}
        response.append(peer_obj)

    return HttpResponse(json.dumps(response),  content_type='application/json')


@csrf_exempt
@require_http_methods(["POST"])
def get_rooms_by_email(request):
    """
    This is called from iOS to get
    rooms that is related to the provided
    email
    Also add this email to Peer model, return the id of the mail
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
                room_obj["contacts"].append(contact.id)
            response.append(room_obj)

        return HttpResponse(json.dumps(response), content_type='application/json')
    except Peer.DoesNotExist:
        Peer.objects.create(email=data["email"])
        return HttpResponse("[]", content_type='application/json')


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
        message_obj = {}
        message_obj["text"] = message.text
        message_obj["sender"] = message.sender
        message_obj["recipient"] = message.recipient
        message_obj["timestamp"] = message.timestamp
        response.append(message_obj)

    return HttpResponse(json.dumps(response), content_type='application/json')


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
        "sender" : 2,
        "recipient" : 3,
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
        sender_id = data["sender"]
        recipient_id = data["recipient"]
        text = data["text"]

        message = Message.objects.create(sender=sender_id, recipient=recipient_id, text=text)
        message.save()
        room.messages.add(message)

    except Room.DoesNotExist:
        return HttpResponse("Err")




