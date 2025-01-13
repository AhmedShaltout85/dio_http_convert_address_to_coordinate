import 'package:flutter/material.dart';
import 'package:pick_location/screens/agora_video_call.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_web/webview_flutter_web.dart';
// import 'package:pick_location/screens/address_to_coordinate.dart';
// import 'package:pick_location/screens/gis_map.dart';
// import 'package:pick_location/screens/login_screen.dart';

void main() {
  // WebViewPlatform.instance =
  //     WebWebViewPlatform(); // Initialize for web platform

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PickLocations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        primaryColor: Colors.indigo,
        primarySwatch: Colors.indigo,
      ),
      // home: const AddressToCoordinates(), //TESTED (WORKING)
      // home: const GisMap(), //TESTED (WORKING-OPEN IN BROWSER & WEBVIEW)
      // home: const LoginScreen(),//TESTED (WORKING)
      home: const AgoraVideoCall(),//TESTED (WORKING)
    );
  }
}
