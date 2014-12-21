from enum import IntEnum
import json

__author__ = 'tdgunes'

class Status(IntEnum):
    Success = 1
    Error = 0
    JSONError = 2


class APIResponseFactory:
    MESSAGES = {
        Status.Success: "Success!",
        Status.Error: "Nooo!"
    }

    @staticmethod
    def create(state, additions = None, message=None):
        if not message:
            message = APIResponseFactory.MESSAGES.get(state, "Something terrible happened.")
        response = {"status": {"message": message, "code": state}}
        if additions:
            for addition in additions:
                response[addition] = additions[addition]
        return json.dumps(response)

