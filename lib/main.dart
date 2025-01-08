import 'package:pick_location/screens/address_to_coordinate.dart';
import 'package:flutter/material.dart';
import 'package:pick_location/screens/gis_map.dart';

void main() {
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
    
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        // useMaterial3: true,
      ),
      // home: const AddressToCoordinates(), //TESTED (WORKING)
      home: const GisMap(),//TESTED (WORKING-OPEN IN BROWSER & WEBVIEW)
    );
  }
}
