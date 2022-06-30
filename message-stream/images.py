import os
import queue
import tempfile
import threading
from time import sleep
import firebase_admin
from firebase_admin import credentials, firestore
import urllib.request

image_queue = queue.Queue()


def read_images():
    cred = credentials.Certificate(
        '/Volumes/GoogleDrive-116811201307747430579/マイドライブ/仕事/Projects/message-bord/message-form-78f18-firebase-adminsdk-gyl2q-8115861505.json')
    firebase_admin.initialize_app(cred)

    db = firestore.client()

    message_ref = db.collection(u'messages').order_by(
        u'createdAt', direction=firestore.Query.DESCENDING)

    def on_snapshot(collection_snapshot, changes, read_time):
        for change in changes:
            image = change.document.get(u'image')
            if change.type.name == 'ADDED' and image is not None:
                image_queue.put(image)

    message_ref.on_snapshot(on_snapshot)


threading.Thread(target=read_images).start()
with tempfile.TemporaryDirectory() as tmpdir:
    while True:
        image = image_queue.get()
        image_file = os.path.join(tmpdir, 'image')
        urllib.request.urlretrieve(image, image_file)
        os.system('clear')
        os.system(f'imgcat {image_file}')
        sleep(5)
