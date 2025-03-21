import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CustomAlertDialogWithSound extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String soundPath;

  const CustomAlertDialogWithSound({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.soundPath,
  });

  void _playSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource(soundPath));
  }

  @override
  Widget build(BuildContext context) {
    // Play sound when the dialog is shown
    WidgetsBinding.instance.addPostFrameCallback((_) => _playSound());

    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}


//  showDialog(
//                 context: context,
//                 builder: (context) => CustomAlertDialogWithSound(
//                   title: 'Alert!',
//                   message: 'This is a custom alert dialog with sound.',
//                   icon: Icons.video_call,
//                   soundPath: 'sounds/alert_sound.mp3', // Add your sound file path
//                 ),
//               );




// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class CustomAlertDialogWithSound extends StatefulWidget {
//   final String title;
//   final String message;
//   final String soundAsset;
//   final VoidCallback? onOk;

//   const CustomAlertDialogWithSound({
//     super.key,
//     required this.title,
//     required this.message,
//     required this.soundAsset,
//     this.onOk,
//   });

//   @override
//   State<CustomAlertDialogWithSound> createState() => _CustomAlertDialogWithSoundState();
// }

// class _CustomAlertDialogWithSoundState extends State<CustomAlertDialogWithSound> {
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     _playSound();
//   }

//   Future<void> _playSound() async {
//     await _audioPlayer.play(AssetSource(widget.soundAsset));
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       contentPadding: const EdgeInsets.all(20),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(Icons.video_call, size: 80, color: Colors.blue),
//           const SizedBox(height: 20),
//           Text(
//             widget.title,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             widget.message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         TextButton(
//           onPressed: () {
//             _audioPlayer.stop();
//             Navigator.of(context).pop();
//             if (widget.onOk != null) widget.onOk!();
//           },
//           child: const Text("OK"),
//         )
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'custom_alert_dialog_with_sound.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Custom Dialog Demo',
//       home: const HomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   void _showDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => const CustomAlertDialogWithSound(
//         title: 'Incoming Video Call',
//         message: 'John Doe is calling you...',
//         soundAsset: 'sounds/ringtone.mp3',
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Call Alert Dialog')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _showDialog(context),
//           child: const Text('Show Alert'),
//         ),
//       ),
//     );
//   }
// }

