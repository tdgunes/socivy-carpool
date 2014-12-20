from django.db import models


class Message(models.Model):
    sender = models.ForeignKey('Peer', null=False, related_name="sender", blank=False)
    recipient = models.ForeignKey('Peer', null=False, related_name="recipient", blank=False)
    text = models.TextField(null=False,blank=False)
    timestamp = models.DateTimeField(auto_now_add=True,null=False, blank=False)

    def __str__(self):
        return "{0} -> {1} message \'{2}\'".format(self.sender, self.recipient, self.text)

class Room(models.Model):
    messages = models.ManyToManyField(Message, blank=True)
    contacts = models.ManyToManyField("Peer")

    def get_contacts_as_str(self):
        str = ", ".join([contact.email for contact in self.contacts.all()])
        return str

    def __str__(self):
        return "Room id: {0} - total messages: {1}".format(self.id, len(self.messages.all()))


class Peer(models.Model):
    email = models.EmailField("Email", unique=True, null=False, blank=False)
    name = models.CharField("Name", null=False, blank=False, max_length=100)
    rooms = models.ManyToManyField(Room, blank=True)

    def __str__(self):
        return self.email

    def get_number_of_rooms(self):
        return len(self.rooms.all())






