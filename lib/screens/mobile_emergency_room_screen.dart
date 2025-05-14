import 'package:flutter/material.dart';

class MobileEmergencyRoomScreen extends StatefulWidget {
  const MobileEmergencyRoomScreen({super.key});

  @override
  State<MobileEmergencyRoomScreen> createState() =>
      _MobileEmergencyRoomScreenState();
}

class _MobileEmergencyRoomScreenState extends State<MobileEmergencyRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "غرفة الطوارئ المتحركة", 
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
      ),
      body: const Center(
        child: Text('Mobile Emergency Room'),
      ),
    );
  }
}
