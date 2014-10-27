
from flask import Flask

import requests
import json

app = Flask(__name__)

CSV = "http://docs.google.com/feeds/download/spreadsheets/Export?key=1zhzQ8bQlyiQMvM5r731jzMu697JmhK3Y3CdiqR9SV78&exportFormat=csv&gid=0"

def get_iett():
    r = requests.get(CSV)
    sections = []
    bucket = []
    for line in r.text.split("\n"):
        if line == "":
            sections.append(bucket)
            bucket = []
            continue
        else:
            bucket.append(line)
    j = []
    for section in sections:
        if section == []:
            continue
        else:
            record = {"id":section[0],
                      "direction": section[1],
                      "hours": section[2:]}
            j.append(record)

    return json.dumps(j, indent=4)

@app.route('/')
def hello_world():
    return get_iett()

if __name__ == '__main__':
    print get_iett()
    app.run(port=8080,host='0.0.0.0')
