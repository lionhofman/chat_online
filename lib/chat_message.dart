import 'dart:ui';

import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic>? data;
  const ChatMessage({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              child: Row(
                children: [
                  data!['senderPhotoUrl'] != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(data!['senderPhotoUrl']),
                          ),
                        )
                      : Container(),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data!['imgUrl'] != null
                          ? Image.network(data!['imgUrl'])
                          : Text(
                              data!['text'],
                              style: const TextStyle(fontSize: 16),
                            ),
                      data!['senderName'] != null
                          ? Text(
                              data!['senderName'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : const Text(''),
                    ],
                  ))
                ],
              ),
            ),
          )
        : Container();
  }
}
