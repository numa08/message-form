import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Map<String, String?> message;

  @override
  Widget build(BuildContext context) {
    return _MessageCard(
      message: message['message']!,
      author: message['name']!,
      imageUrl: message['image'],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    Key? key,
    required this.message,
    required this.author,
    this.imageUrl,
  }) : super(key: key);
  final String message;
  final String author;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                width: 480,
                height: 480,
              ),
          ],
        ),
      ),
    );
  }
}
