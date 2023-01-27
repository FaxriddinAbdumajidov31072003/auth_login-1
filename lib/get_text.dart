import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class GetText extends StatefulWidget {
  const GetText({Key? key}) : super(key: key);

  @override
  State<GetText> createState() => _GetTextState();
}

class _GetTextState extends State<GetText> {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String title = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text"),
      ),
      body: Center(
        child: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          XFile? image =
              // ignore: invalid_use_of_visible_for_testing_member
              await ImagePicker.platform.getImage(source: ImageSource.gallery);
          final RecognizedText recognizedText = await textRecognizer
              .processImage(InputImage.fromFile(File(image?.path ?? "")));
          String text = recognizedText.text;
          title = text;
          setState(() {});
          // for (TextBlock block in recognizedText.blocks) {
          //   final Rect rect = block.rect;
          //   final List<Offset> cornerPoints = block.cornerPoints;
          //   final String text = block.text;
          //   final List<String> languages = block.recognizedLanguages;
          //
          //   for (TextLine line in block.lines) {
          //     // Same getters as TextBlock
          //     for (TextElement element in line.elements) {
          //       // Same getters as TextBlock
          //     }
          //   }
          // }
        },
      ),
    );
  }
}
