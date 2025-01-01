
//from pub.dev agora_rtc_engine

import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/dio_http_constants.dart';



class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

//from chat_gpt
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';

// class VideoCallScreen extends StatefulWidget {
//   const VideoCallScreen({super.key});

//   @override
//   VideoCallScreenState createState() => VideoCallScreenState();
// }

// class VideoCallScreenState extends State<VideoCallScreen> {
//   final String appId = "YOUR_AGORA_APP_ID";
//   final String channelName = "test";
//   final String token = "YOUR_AGORA_TOKEN";

//   late RtcEngine _engine;

//   @override
//   void initState() {
//     super.initState();
//     initializeAgora();
//   }

//   Future<void> initializeAgora() async {
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(appId: appId));
//     await _engine.enableVideo();
//     await _engine.joinChannel(token: token, channelId: channelName, uid: 0, options: const ChannelMediaOptions());
//     // joinChannel(token, channelName, null, 0);
//     // await _engine.joinChannel(token, channelName, null, 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Agora Video Call')),
//       body: Container(), // Display video stream here
//     );
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }
// }
