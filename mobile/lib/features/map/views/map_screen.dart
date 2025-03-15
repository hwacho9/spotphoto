import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지도'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('지도 화면'),
      ),
    );
  }
}
