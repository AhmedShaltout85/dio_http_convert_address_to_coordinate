import 'package:flutter/material.dart';

class Tracking extends StatelessWidget {
  const Tracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
        title: const Text(
          'Tracking',
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
      ),
      body: const Center(
        child: Text('Tracking'),
      ),
    );
  }
}
