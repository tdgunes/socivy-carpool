
from django.contrib.auth.models import Group
from django.contrib import admin

from .models import Message, Peer, Room


class MessageAdmin(admin.ModelAdmin):
    list_display = ('text', 'sender', 'timestamp')
    list_filter = ['timestamp']

class PeerAdmin(admin.ModelAdmin):
    list_display = ('email', 'get_number_of_rooms')

class RoomAdmin(admin.ModelAdmin):
    list_display = ('id','get_contacts_as_str')
    list_filter = ['id']

admin.site.register(Message, MessageAdmin)
admin.site.register(Peer, PeerAdmin)
admin.site.register(Room, RoomAdmin)
admin.site.unregister(Group)

