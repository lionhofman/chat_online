import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                data['senderName'] != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: mine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: Text(
                                data['senderName'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              formatDateTimeFromFirestone(data),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text(''),
                data['imgUrl'] != null
                    ? Image.network(data['imgUrl'])
                    : Text(
                        data['text'],
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: const TextStyle(fontSize: 16),
                      ),
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

  String formatDateTimeFromFirestone(Map<String, dynamic> data) {
    DateTime dt = DateTime.now();
    if (data['time'] != null) {
      dt = (data['time'] as Timestamp).toDate();
    }
    return DateFormat('HH:mm a').format(dt); //22:00 PM
  }
}
