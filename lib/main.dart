import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraExample(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [CameraExample()],
    ));
  }
}

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  File? _image;
  final picker = ImagePicker();
  final String _answer = '';
  TranslateLanguage korean = TranslateLanguage.korean;
  TranslateLanguage english = TranslateLanguage.english;

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? const Text('No image selected.')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25.0),
            showImage(),
            const SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 카메라 촬영 버튼
                FloatingActionButton(
                  tooltip: 'pick Iamge',
                  heroTag: 'btn1',
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  child: const Icon(Icons.add_a_photo),
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  tooltip: 'pick Iamge',
                  heroTag: 'btn2',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  child: const Icon(Icons.wallpaper),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  final inputImage = InputImage.fromFile(_image!);
                  final textRecognizer =
                      TextRecognizer(script: TextRecognitionScript.korean);
                  final RecognizedText recognizedText =
                      await textRecognizer.processImage(inputImage);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return OCR(text: recognizedText.text);
                    },
                  ));
                },
                child: const Text("")),
            Text(_answer)
          ],
        ));
  }
}

class OCR extends StatelessWidget {
  OCR({super.key, required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(text),
          ],
        ),
      ),
    );
  }
}
