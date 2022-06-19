import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:message_form/firebase_options.dart';
import 'package:message_form/screen/form_screen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (const bool.hasEnvironment('emulator')) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormScreen(),
    );
  }
}
