import 'package:flutter/material.dart';
import 'package:pick_location/screens/receiver_screen.dart';

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
          style: TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
      ),
      body: Center(
        child: IconButton(
          tooltip: "فضلا, قم بالضغط على الايقون للتمكن من بث الفيديو",
          hoverColor: Colors.yellow,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReceiverScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.videocam_outlined,
            color: Colors.indigo,
            size: 70,
          ),
        ),
      ),
    );
  }
}
