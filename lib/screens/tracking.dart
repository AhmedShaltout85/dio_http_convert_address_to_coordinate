import 'package:flutter/material.dart';

class Tracking extends StatelessWidget {
  const Tracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Tracking', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text('Tracking'),
      ),
    );
  }
}
