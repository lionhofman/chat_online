import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final Function({String? text, PickedFile? imgFile}) sendMessage;
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
          IconButton(
              onPressed: () async {
                final PickedFile? imgFile = await ImagePicker.platform
                    .pickImage(source: ImageSource.camera);
                if (imgFile == null) return;
                widget.sendMessage(imgFile: imgFile);
              },
              icon: const Icon(Icons.photo_camera)),
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
              widget.sendMessage(text: text);
              _resetText();
            },
          )),
          IconButton(
              onPressed: _isComposing
                  ? () {
                      widget.sendMessage(text: _textController.text);
                      _resetText();
                    }
                  : null,
              icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
