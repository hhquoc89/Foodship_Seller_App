import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  Image? img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: controller,
            ),
            ElevatedButton(
                onPressed: _onPressedButton, child: const Text("Create Image")),
            Container(
                width: 200,
                height: 200,
                color: Colors.blueGrey,
                child: img ?? Container())
          ],
        ),
      ),
    );
  }

  void getCanvasImage(String str) async {
    var builder = ParagraphBuilder(ParagraphStyle(fontStyle: FontStyle.normal));
    builder.addText(str);
    Paragraph paragraph = builder.build();
    paragraph.layout(const ParagraphConstraints(width: 100));

    final recorder = PictureRecorder();
    var newCanvas = Canvas(recorder);

    newCanvas.drawParagraph(paragraph, Offset.zero);

    final picture = recorder.endRecording();
    var res = await picture.toImage(100, 100);
    ByteData? data = await res.toByteData(format: ImageByteFormat.png);

    if (data != null) {
      img = Image.memory(Uint8List.view(data.buffer));
    }

    setState(() {
      print(data);
    });
  }

  void _onPressedButton() {
    getCanvasImage(controller.text);
  }
}
