import os
import firebase_admin
from firebase_admin import credentials, firestore

# Use a service account
cred = credentials.Certificate(
    '/Volumes/GoogleDrive-116811201307747430579/マイドライブ/仕事/Projects/message-bord/message-form-78f18-firebase-adminsdk-gyl2q-8115861505.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

message_ref = db.collection(u'messages').order_by(
    u'createdAt', direction=firestore.Query.DESCENDING)


def on_snapshot(collection_snapshot, changes, read_time):
    os.system('clear')
    for doc in collection_snapshot:
        print(f'\033[1m{doc.get("name")}\033[0m:\n{doc.get("message")}\n')


message_ref.on_snapshot(on_snapshot)

while(True):
    pass
