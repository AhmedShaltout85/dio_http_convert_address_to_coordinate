import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:permission_handler/permission_handler.dart';

import '../network/remote/dio_network_repos.dart';

class VideoCallScreen extends StatefulWidget {
  final String roomId;

  const VideoCallScreen({
    super.key,
    required this.roomId,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  IO.Socket? _socket;
  bool _isConnected = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  String _connectionStatus = 'جارى الاتصال';
  bool _isDisposed = false;
  bool _isFrontCamera = true; // Track current camera

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeRenderersAndCall();
  }

  Future<void> _requestPermissions() async {
    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();
    } catch (e) {
      _showErrorDialog('خطأ في الصلاحيات: $e');
    }
  }

  Future<void> _initializeRenderersAndCall() async {
    try {
      await _initRenderers();
      await _initializeCall();
    } catch (e) {
      _safeUpdateConnectionStatus('Initialization error: $e');
      _showErrorDialog('Call initialization failed: $e');
    }
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _initializeCall() async {
    await _createPeerConnection();
    await _getUserMedia();
    _connectSocket();
  }

  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      if (_isDisposed) return;
      _socket?.emit('ice-candidate', {
        'roomId': widget.roomId,
        'candidate': candidate.toMap(),
      });
    };

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        _safeSetState(() {
          _remoteStream = event.streams[0];
          _remoteRenderer.srcObject = _remoteStream;
          _safeUpdateConnectionStatus('Connected');
        });
      }
    };

    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      _safeUpdateConnectionStatus(_getConnectionStatusText(state));
    };
  }

  String _getConnectionStatusText(RTCIceConnectionState state) {
    switch (state) {
      case RTCIceConnectionState.RTCIceConnectionStateConnected:
        return 'متصل';
      case RTCIceConnectionState.RTCIceConnectionStateChecking:
        return 'جارى الاتصال...';
      case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
        return 'غير متصل';
      case RTCIceConnectionState.RTCIceConnectionStateFailed:
        return 'فشل الاتصال';
      default:
        return 'غير معروف';
    }
  }

  Future<void> _getUserMedia() async {
    try {
      final mediaConstraints = {
        'audio': true,
        'video': {
          'facingMode': _isFrontCamera ? 'user' : 'environment',
          'width': {'ideal': 640},
          'height': {'ideal': 480},
        }
      };

      _localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = _localStream;

      // Add all tracks to peer connection
      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });
    } catch (e) {
      _showErrorDialog(
          'فصلا تأكد من وجود الكاميرا والمايك, والسماح للوصول اليهم: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_localStream == null || _peerConnection == null) return;

    try {
      // Toggle camera direction
      _isFrontCamera = !_isFrontCamera;

      // Get new media with the opposite facing mode
      final mediaConstraints = {
        'audio': true,
        'video': {
          'facingMode': _isFrontCamera ? 'user' : 'environment',
          'width': {'ideal': 640},
          'height': {'ideal': 480},
        }
      };

      // Get the new stream
      final newStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      // Replace the old video track with the new one
      final newVideoTrack = newStream.getVideoTracks()[0];
      final oldVideoTrack = _localStream!.getVideoTracks()[0];

      // Get all senders and find the video sender
      final senders = await _peerConnection!.getSenders();
      final videoSender = senders.firstWhere(
        (sender) => sender.track?.kind == 'video',
      );

      await videoSender.replaceTrack(newVideoTrack);

      // Update the local stream
      _localStream!.removeTrack(oldVideoTrack);
      _localStream!.addTrack(newVideoTrack);
      _localRenderer.srcObject = _localStream;

      // Stop the old track and close the temporary stream
      oldVideoTrack.stop();
      newStream.getAudioTracks().forEach((track) => track.stop());
    } catch (e) {
      _showErrorDialog('خطأ في تغيير الكاميرا: $e');
    }
  }

  void _connectSocket() {
    try {
      // _socket = IO.io('ws://10.170.0.190:3000', <String, dynamic>{
      _socket = IO.io(WEBRTC_BASE_URI_IP_ADDRESS_WEB_SOCKET, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket!.connect();

      _socket!.on('connect', (_) {
        _safeSetState(() => _isConnected = true);
        _socket!.emit('join-room', widget.roomId);
        _safeUpdateConnectionStatus('Connected to server');
      });

      _socket!.on('user-connected', (_) async {
        if (_isDisposed) return;
        await _createOffer();
      });

      _socket!.on('offer', (data) async {
        if (_isDisposed) return;
        await _handleOffer(data);
      });

      _socket!.on('answer', (data) async {
        if (_isDisposed) return;
        await _handleAnswer(data);
      });

      _socket!.on('ice-candidate', (data) async {
        if (_isDisposed) return;
        await _handleIceCandidate(data);
      });

      _socket!.on('disconnect', (_) {
        _safeSetState(() => _isConnected = false);
        _safeUpdateConnectionStatus('Disconnected from server');
      });
    } catch (e) {
      _showErrorDialog('Failed to connect to server: $e');
    }
  }

  Future<void> _createOffer() async {
    try {
      if (_peerConnection == null || _isDisposed) return;

      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      _socket?.emit('offer', {
        'roomId': widget.roomId,
        'offer': offer.toMap(),
      });
    } catch (e) {
      _showErrorDialog('Failed to create offer: $e');
    }
  }

  Future<void> _handleOffer(dynamic data) async {
    try {
      if (_peerConnection == null || _isDisposed) return;

      final offer = RTCSessionDescription(
        data['offer']['sdp'],
        data['offer']['type'],
      );

      await _peerConnection!.setRemoteDescription(offer);

      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      _socket?.emit('answer', {
        'roomId': widget.roomId,
        'answer': answer.toMap(),
      });
    } catch (e) {
      _showErrorDialog('Failed to handle offer: $e');
    }
  }

  Future<void> _handleAnswer(dynamic data) async {
    try {
      if (_peerConnection == null || _isDisposed) return;

      final answer = RTCSessionDescription(
        data['answer']['sdp'],
        data['answer']['type'],
      );

      await _peerConnection!.setRemoteDescription(answer);
    } catch (e) {
      _showErrorDialog('Failed to handle answer: $e');
    }
  }

  Future<void> _handleIceCandidate(dynamic data) async {
    try {
      if (_peerConnection == null || _isDisposed) return;

      final candidate = RTCIceCandidate(
        data['candidate']['candidate'],
        data['candidate']['sdpMid'],
        data['candidate']['sdpMLineIndex'],
      );

      await _peerConnection!.addCandidate(candidate);
    } catch (e) {
      debugPrint('Error adding ICE candidate: $e');
    }
  }

  void _toggleMute() {
    _safeSetState(() {
      _isMuted = !_isMuted;
      _localStream?.getAudioTracks().forEach((track) {
        track.enabled = !_isMuted;
      });
    });
  }

  void _toggleVideo() {
    _safeSetState(() {
      _isVideoEnabled = !_isVideoEnabled;
      _localStream?.getVideoTracks().forEach((track) {
        track.enabled = _isVideoEnabled;
      });
    });
  }

  void _endCall() {
    // Navigator.pop(context);
    if (context.canPop()) {
      context.pop();
    } else {
      // Handle the case when you can't pop (e.g., navigate to home)
      context.go('/emergency');
    }
     DioNetworkRepos()
        .updateLocationBrokenByAddressUpdateVideoCall(widget.roomId, 0);
  }

  void _safeUpdateConnectionStatus(String status) {
    _safeSetState(() => _connectionStatus = status);
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  void _showErrorDialog(String message) {
    if (_isDisposed) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video (full screen)
            _remoteStream != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RTCVideoView(
                      _remoteRenderer,
                      mirror: false,
                      objectFit: RTCVideoViewObjectFit
                          .RTCVideoViewObjectFitContain, // Set to RTCVideoViewObjectFitContain
                      // objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, // Set to RTCVideoViewObjectFitContain
                    ),
                  )
                : Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'فى إنتظار الربط مع الطرف الاخر',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _connectionStatus,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            // Local video (small window)
            Positioned(
              top: 20,
              right: 20,
              child: SizedBox(
                width: 120,
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: RTCVideoView(
                    _localRenderer,
                    mirror: _isFrontCamera, // Only mirror for front camera
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ),
            ),

            // Status indicator
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isConnected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _connectionStatus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Control buttons
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    onPressed: _toggleMute,
                    backgroundColor: _isMuted ? Colors.red : Colors.white24,
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    onPressed: _endCall,
                    backgroundColor: Colors.red,
                  ),
                  _buildControlButton(
                    icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                    onPressed: _toggleVideo,
                    backgroundColor:
                        _isVideoEnabled ? Colors.white24 : Colors.red,
                  ),
                  _buildControlButton(
                    icon: Icons.cameraswitch,
                    onPressed: _switchCamera,
                    backgroundColor: Colors.white24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Clean up WebRTC resources
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.getTracks().forEach((track) => track.stop());
    _remoteStream?.getTracks().forEach((track) => track.stop());
    _peerConnection?.close();

    // Clean up socket.io resources
    _socket?.off('connect');
    _socket?.off('user-connected');
    _socket?.off('offer');
    _socket?.off('answer');
    _socket?.off('ice-candidate');
    _socket?.off('disconnect');
    _socket?.disconnect();
    _socket?.close();

    super.dispose();
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class VideoCallScreen extends StatefulWidget {
//   final String roomId;

//   const VideoCallScreen({Key? key, required this.roomId}) : super(key: key);

//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   MediaStream? _remoteStream;

//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

//   IO.Socket? _socket;
//   bool _isConnected = false;
//   bool _isMuted = false;
//   bool _isVideoEnabled = true;
//   String _connectionStatus = 'Connecting...';
//   bool _isDisposed = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderersAndCall();
//   }

//   Future<void> _initializeRenderersAndCall() async {
//     try {
//       await _initRenderers();
//       await _initializeCall();
//     } catch (e) {
//       _safeUpdateConnectionStatus('Initialization error: $e');
//       _showErrorDialog('Call initialization failed: $e');
//     }
//   }

//   Future<void> _initRenderers() async {
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }

//   Future<void> _initializeCall() async {
//     await _createPeerConnection();
//     await _getUserMedia();
//     _connectSocket();
//   }

//   Future<void> _createPeerConnection() async {
//     final configuration = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {'urls': 'stun:stun1.l.google.com:19302'},
//       ]
//     };

//     _peerConnection = await createPeerConnection(configuration);

//     _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
//       if (_isDisposed) return;
//       _socket?.emit('ice-candidate', {
//         'roomId': widget.roomId,
//         'candidate': candidate.toMap(),
//       });
//     };

//     _peerConnection?.onTrack = (RTCTrackEvent event) {
//       if (event.track.kind == 'video' && event.streams.isNotEmpty) {
//         _safeSetState(() {
//           _remoteStream = event.streams[0];
//           _remoteRenderer.srcObject = _remoteStream;
//           _safeUpdateConnectionStatus('Connected');
//         });
//       }
//     };

//     _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
//       _safeUpdateConnectionStatus(_getConnectionStatusText(state));
//     };
//   }

//   String _getConnectionStatusText(RTCIceConnectionState state) {
//     switch (state) {
//       case RTCIceConnectionState.RTCIceConnectionStateConnected:
//         return 'Connected';
//       case RTCIceConnectionState.RTCIceConnectionStateChecking:
//         return 'Connecting...';
//       case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
//         return 'Disconnected';
//       case RTCIceConnectionState.RTCIceConnectionStateFailed:
//         return 'Connection failed';
//       default:
//         return 'Unknown';
//     }
//   }

//   Future<void> _getUserMedia() async {
//     try {
//       final mediaConstraints = {
//         'audio': true,
//         'video': {
//           'facingMode': 'user',
//           'width': {'ideal': 640},
//           'height': {'ideal': 480},
//         }
//       };

//       _localStream =
//           await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       _localRenderer.srcObject = _localStream;

//       // Add all tracks to peer connection
//       _localStream?.getTracks().forEach((track) {
//         _peerConnection?.addTrack(track, _localStream!);
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to access camera/microphone: $e');
//     }
//   }

//   void _connectSocket() {
//     try {
//       _socket = IO.io('ws://10.170.0.190:3000', <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': false,
//       });

//       _socket!.connect();

//       _socket!.on('connect', (_) {
//         _safeSetState(() => _isConnected = true);
//         _socket!.emit('join-room', widget.roomId);
//         _safeUpdateConnectionStatus('Connected to server');
//       });

//       _socket!.on('user-connected', (_) async {
//         if (_isDisposed) return;
//         await _createOffer();
//       });

//       _socket!.on('offer', (data) async {
//         if (_isDisposed) return;
//         await _handleOffer(data);
//       });

//       _socket!.on('answer', (data) async {
//         if (_isDisposed) return;
//         await _handleAnswer(data);
//       });

//       _socket!.on('ice-candidate', (data) async {
//         if (_isDisposed) return;
//         await _handleIceCandidate(data);
//       });

//       _socket!.on('disconnect', (_) {
//         _safeSetState(() => _isConnected = false);
//         _safeUpdateConnectionStatus('Disconnected from server');
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to connect to server: $e');
//     }
//   }

//   Future<void> _createOffer() async {
//     try {
//       if (_peerConnection == null || _isDisposed) return;

//       final offer = await _peerConnection!.createOffer();
//       await _peerConnection!.setLocalDescription(offer);

//       _socket?.emit('offer', {
//         'roomId': widget.roomId,
//         'offer': offer.toMap(),
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to create offer: $e');
//     }
//   }

//   Future<void> _handleOffer(dynamic data) async {
//     try {
//       if (_peerConnection == null || _isDisposed) return;

//       final offer = RTCSessionDescription(
//         data['offer']['sdp'],
//         data['offer']['type'],
//       );

//       await _peerConnection!.setRemoteDescription(offer);

//       final answer = await _peerConnection!.createAnswer();
//       await _peerConnection!.setLocalDescription(answer);

//       _socket?.emit('answer', {
//         'roomId': widget.roomId,
//         'answer': answer.toMap(),
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to handle offer: $e');
//     }
//   }

//   Future<void> _handleAnswer(dynamic data) async {
//     try {
//       if (_peerConnection == null || _isDisposed) return;

//       final answer = RTCSessionDescription(
//         data['answer']['sdp'],
//         data['answer']['type'],
//       );

//       await _peerConnection!.setRemoteDescription(answer);
//     } catch (e) {
//       _showErrorDialog('Failed to handle answer: $e');
//     }
//   }

//   Future<void> _handleIceCandidate(dynamic data) async {
//     try {
//       if (_peerConnection == null || _isDisposed) return;

//       final candidate = RTCIceCandidate(
//         data['candidate']['candidate'],
//         data['candidate']['sdpMid'],
//         data['candidate']['sdpMLineIndex'],
//       );

//       await _peerConnection!.addCandidate(candidate);
//     } catch (e) {
//       debugPrint('Error adding ICE candidate: $e');
//     }
//   }

//   void _toggleMute() {
//     _safeSetState(() {
//       _isMuted = !_isMuted;
//       _localStream?.getAudioTracks().forEach((track) {
//         track.enabled = !_isMuted;
//       });
//     });
//   }

//   void _toggleVideo() {
//     _safeSetState(() {
//       _isVideoEnabled = !_isVideoEnabled;
//       _localStream?.getVideoTracks().forEach((track) {
//         track.enabled = _isVideoEnabled;
//       });
//     });
//   }

//   void _endCall() {
//     Navigator.pop(context);
//   }

//   void _safeUpdateConnectionStatus(String status) {
//     _safeSetState(() => _connectionStatus = status);
//   }

//   void _safeSetState(VoidCallback fn) {
//     if (!_isDisposed && mounted) {
//       setState(fn);
//     }
//   }

//   void _showErrorDialog(String message) {
//     if (_isDisposed) return;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Remote video (full screen)
//             _remoteStream != null
//                 ? RTCVideoView(
//                     _remoteRenderer,
//                     mirror: false,
//                     objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                   )
//                 : Container(
//                     color: Colors.grey[800],
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.person,
//                             size: 100,
//                             color: Colors.white54,
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Waiting for other participant...',
//                             style: TextStyle(
//                               color: Colors.white54,
//                               fontSize: 18,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             _connectionStatus,
//                             style: const TextStyle(
//                               color: Colors.white70,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//             // Local video (small window)
//             Positioned(
//               top: 20,
//               right: 20,
//               child: SizedBox(
//                 width: 120,
//                 height: 160,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: RTCVideoView(
//                     _localRenderer,
//                     mirror: true,
//                     objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//                   ),
//                 ),
//               ),
//             ),

//             // Status indicator
//             Positioned(
//               top: 20,
//               left: 20,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: _isConnected ? Colors.green : Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   _connectionStatus,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             // Control buttons
//             Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildControlButton(
//                     icon: _isMuted ? Icons.mic_off : Icons.mic,
//                     onPressed: _toggleMute,
//                     backgroundColor: _isMuted ? Colors.red : Colors.white24,
//                   ),
//                   _buildControlButton(
//                     icon: Icons.call_end,
//                     onPressed: _endCall,
//                     backgroundColor: Colors.red,
//                   ),
//                   _buildControlButton(
//                     icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
//                     onPressed: _toggleVideo,
//                     backgroundColor:
//                         _isVideoEnabled ? Colors.white24 : Colors.red,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//     required Color backgroundColor,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           color: Colors.white,
//           size: 28,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;

//     // Clean up WebRTC resources
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _localStream?.getTracks().forEach((track) => track.stop());
//     _remoteStream?.getTracks().forEach((track) => track.stop());
//     _peerConnection?.close();

//     // Clean up socket.io resources
//     _socket?.off('connect');
//     _socket?.off('user-connected');
//     _socket?.off('offer');
//     _socket?.off('answer');
//     _socket?.off('ice-candidate');
//     _socket?.off('disconnect');
//     _socket?.disconnect();
//     _socket?.close();

//     super.dispose();
//   }
// }