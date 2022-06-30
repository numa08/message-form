import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' hide Animation, Image;

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);
  final uuid = const Uuid();

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  PickedFile? imageFile;

  @override
  void initState() {
    _loadName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _FormScreen(
      formKey: _formKey,
      nameController: _nameController,
      messageController: _messageController,
      image: imageFile?.path,
      onPressPickImage: _pickImage,
      onPressSend: () async {
        if (_formKey.currentState!.validate()) {
          await _sendMessage();
          showDialog(
            context: context,
            builder: (context) => _completeSendDialog(context),
          );
        }
      },
    );
  }

  Future<void> _loadName() async {
    final pref = await SharedPreferences.getInstance();
    final name = pref.getString('name');
    if (name != null) {
      _nameController.text = name;
    }
  }

  Future<void> _sendMessage() async {
    _showProgressDialog();
    final pref = await SharedPreferences.getInstance();
    await pref.setString('name', _nameController.text);
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage();
    }
    final messageData = <String, dynamic>{
      'name': _nameController.text,
      'message': _messageController.text,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
    final database = FirebaseFirestore.instance;
    await database.collection('messages').add(messageData);

    _messageController.text = '';
    setState(() {
      imageFile = null;
    });
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePickerPlugin().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future<String> _uploadImage() async {
    assert(imageFile != null);
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('images/${widget.uuid.v1()}.jpg');
    final imageData = await imageFile!.readAsBytes();
    final rowImageByte = decodeImage(imageData)!;
    final jpegData = Uint8List.fromList(encodeJpg(rowImageByte));
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(jpegData, metaData);
    return await ref.getDownloadURL();
  }

  void _showProgressDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class _FormScreen extends StatelessWidget {
  const _FormScreen({
    Key? key,
    required this.nameController,
    required this.messageController,
    required this.formKey,
    this.image,
    required this.onPressPickImage,
    required this.onPressSend,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController messageController;
  final GlobalKey<FormState> formKey;
  final String? image;
  final void Function(ImageSource source) onPressPickImage;
  final VoidCallback onPressSend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新郎新婦へ贈るメッセージ'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onPressSend();
        },
        child: const Icon(Icons.send),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 4,
                  ),
                  const Text('あなたのお名前（ニックネーム・ハンドルネームでも可能です）'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'お名前（20文字以内）',
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'お名前を入力してください';
                      }
                      if (value.length > 20) {
                        return 'お名前は20文字以内で入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text('新郎新婦に贈るメッセージや質問をどうぞ。披露宴の途中でご紹介します。'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'メッセージ',
                    ),
                    controller: messageController,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'メッセージを入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text('新郎・新婦との思い出の写真や式の様子をアップロードしてください。披露宴の途中で紹介します'),
                  const SizedBox(
                    height: 4,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      onPressPickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('写真を撮影'),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      onPressPickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('写真を選択'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Builder(builder: (context) {
                    if (image != null) {
                      return Image.network(image!);
                    } else {
                      return Container();
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

AlertDialog _completeSendDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('送信しました'),
    content: const Text('メッセージを送信しました。メッセージは何度でも送信可能です。ぜひ、別のメッセージも贈ってください。'),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
    ],
  );
}
