__author__ = 'tdgunes'


from django.conf.urls import patterns, url
from . import views

urlpatterns = patterns('',
    url(r'^start_room/', views.start_room, name='start_room'),
    url(r'^get_all_chat_users/',views.get_all_chat_users, name='get_all_chat_users'),
    url(r'^get_rooms_by_email/', views.get_rooms_by_email, name='get_rooms_by_email'),
    url(r'^get_room_conversation/', views.get_room_conversation, name='get_room_conversation'),
    # store_message for internal purposes
    url(r'^store_message/', views.store_message, name='store_message'),
)
