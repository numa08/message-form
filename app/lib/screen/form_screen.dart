import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  Widget build(BuildContext context) {
    return _FormScreen(
      onPressSend: () async {
        showDialog(
          context: context,
          builder: (context) => _completeSendDialog(context),
        );
      },
    );
  }
}

class _FormScreen extends StatelessWidget {
  const _FormScreen({
    Key? key,
    required this.onPressSend,
  }) : super(key: key);

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
      body: SafeArea(
        child: Form(
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
                    labelText: 'お名前',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('新郎新婦に贈るメッセージや質問をどうぞ。披露宴の途中でご紹介します。'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'メッセージ',
                  ),
                  maxLines: null,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('新郎・新婦との思い出の写真や式の様子をアップロードしてください。披露宴の途中で紹介します'),
                const SizedBox(
                  height: 4,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('写真を撮影'),
                ),
                const SizedBox(
                  height: 4,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.image),
                  label: const Text('写真を選択'),
                ),
              ],
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
