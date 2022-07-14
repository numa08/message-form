import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:viewer/widget/message_card.dart';

class ViwerScreen extends StatefulWidget {
  const ViwerScreen({Key? key}) : super(key: key);

  @override
  State<ViwerScreen> createState() => _ViwerScreenState();
}

class _ViwerScreenState extends State<ViwerScreen> {
  List<Map<String, String?>> _messages = [];

  @override
  void initState() {
    _watchMessages();
    super.initState();
  }

  void _watchMessages() {
    final firestore = FirebaseFirestore.instance;
    final messages =
        firestore.collection('messages').orderBy('createdAt', descending: true);
    messages.snapshots().listen((snapshot) {
      setState(() {
        _messages = snapshot.docs.map((doc) {
          final data = doc.data();
          return <String, String?>{
            'message': data['message'],
            'name': data['name'],
            'image': data['image'],
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewer'),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MessageCard(
              message: message,
            ),
          );
        },
      ),
    );
  }
}
