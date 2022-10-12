import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  final Function(String) sendMessage;
  const TextComposer({Key? key, required this.sendMessage}) : super(key: key);

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final TextEditingController _textController = TextEditingController();
  void _resetText() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo_camera)),
          Expanded(
              child: TextField(
            decoration: const InputDecoration.collapsed(
                hintText: 'Enviar uma Mensagem'),
            controller: _textController,
            onChanged: (text) {
              setState(() {
                _isComposing = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              widget.sendMessage(text);
              _resetText();
            },
          )),
          IconButton(
              onPressed: _isComposing
                  ? () {
                      widget.sendMessage(_textController.text);
                      _resetText();
                    }
                  : null,
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
