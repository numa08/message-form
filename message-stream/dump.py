import firebase_admin
from firebase_admin import credentials, firestore
import json
import os
from urllib import request
import re

image_regex = r"(.*%2F)(.*\.jpg)"

# Use a service account
cred = credentials.Certificate(
    '/Volumes/GoogleDrive-116811201307747430579/マイドライブ/仕事/Projects/message-bord/message-form-78f18-firebase-adminsdk-gyl2q-8115861505.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

messages = db.collection(u'messages').order_by(
    u'createdAt', direction=firestore.Query.DESCENDING
).stream()

with open('messages.jsonl', 'w') as f:
    for message in messages:
        data = message.to_dict()
        data.pop('createdAt')
        image = data.get('image')
        matches = re.findall(image_regex, image, re.MULTILINE) if image else []
        image_file_name = matches[0][1] if len(matches) > 0 else None
        if image_file_name is not None:
            os.makedirs('images', exist_ok=True)
            image_file = os.path.join('images', image_file_name)
            request.urlretrieve(image, image_file)
            data['image'] = image_file_name
        f.write(json.dumps(data, ensure_ascii=False) + '\n')
