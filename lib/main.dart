import 'package:dio_http/screens/address_to_coordinate.dart';
// import 'package:dio_http/screens/home_screen.dart';
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.indigo,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        // useMaterial3: true,
      ),
      home: const AddressToCoordinates(),
    );
  }
}
