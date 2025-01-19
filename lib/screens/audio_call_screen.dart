// // for the audio call it’s so similar :


// // ignore_for_file: library_private_types_in_public_api

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../utils/dio_http_constants.dart';

// class AudioCallScreen extends StatefulWidget {
//   const AudioCallScreen({super.key});

//   @override
//   _AudioCallScreenState createState() => _AudioCallScreenState();
// }

// class _AudioCallScreenState extends State<AudioCallScreen> {
//   late int _remoteUid;
//   late RtcEngine _engine;
//   bool _localUserJoined = false;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _engine.leaveChannel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             color: Colors.black87,
//             child: Center(
//               child: _remoteUid == 0
//                   ? const Text(
//                       'Calling …',
//                       style: TextStyle(color: Colors.white),
//                     )
//                   : Text(
//                       'Calling with $_remoteUid',
//                     ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 25.0, right: 25),
//               child: Container(
//                 height: 50,
//                 color: Colors.black12,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(true);
//                         },
//                         icon: const Icon(
//                           Icons.call_end,
//                           size: 44,
//                           color: Colors.redAccent,
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> initAgora() async {
//     await [Permission.microphone, Permission.camera].request();
//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//     _engine.enableAudio();
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = 0;
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           debugPrint(
//               '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
//         },
//       ),
//     );

//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableAudio();
//     await _engine.startPreview();

//     await _engine.joinChannel(
//       token: token,
//       channelId: channel,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );

//     Widget _renderRemoteAudio() {
//       if (_remoteUid != 0) {
//         return Text(
//           'Calling with $_remoteUid',
//           style: const TextStyle(color: Colors.white),
//         );
//       } else {
//         return const Text(
//           'Calling …',
//           style: TextStyle(color: Colors.white),
//         );
//       }


//     }

//   }
// }
