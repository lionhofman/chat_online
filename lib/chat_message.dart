import 'dart:ui';

import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool mine;
  const ChatMessage({Key? key, required this.data, required this.mine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child: Row(
          children: [
            !mine && data['senderPhotoUrl'] != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data['senderPhotoUrl']),
                    ),
                  )
                : Container(),
            Expanded(
                child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data['imgUrl'] != null
                    ? Image.network(data['imgUrl'])
                    : Text(
                        data['text'],
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(fontSize: 16),
                      ),
                data['senderName'] != null
                    ? Text(
                        data['senderName'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Text(''),
              ],
            )),
            mine && data['senderPhotoUrl'] != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data['senderPhotoUrl']),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
