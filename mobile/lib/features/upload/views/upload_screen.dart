import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('업로드'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('사진 업로드 화면'),
      ),
    );
  }
}
