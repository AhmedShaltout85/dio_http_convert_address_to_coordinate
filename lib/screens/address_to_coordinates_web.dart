import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import '../utils/dio_http_constants.dart';

class AddressToCoordinates extends StatefulWidget {
  const AddressToCoordinates({super.key});

  @override
  AddressToCoordinatesState createState() => AddressToCoordinatesState();
}

class AddressToCoordinatesState extends State<AddressToCoordinates> {
  String address =
      "Grinfel, Bab Sharqi WA Wabour Al Meyah, Bab Sharqi, Alexandria Governorate 5422001";

  String coordinates = "";
  String apiKey =
      'AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk'; // Replace with your actual Google API key

  // Function to get latitude and longitude from an address using Google Geocoding API
  Future<void> _getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // final data = json.decode(response.body);
        final data = json.decode(response.body);
        debugPrintStack(label: "Coordinates: $data");
        debugPrintStack(label: "Coordinates: $response.body");
        debugPrint(response.toString());

        if (data['status'] == 'OK') {
          var location = data['results'][0]['geometry']['location'];
          setState(() {
            coordinates =
                "Latitude: ${location['lat']}, Longitude: ${location['lng']}";
          });
        } else {
          setState(() {
            coordinates = "Error: ${data['status']}";
          });
        }
      } else {
        setState(() {
          coordinates = "Error: Failed to fetch data";
        });
      }
    } catch (e) {
      setState(() {
        coordinates = "Error: Unable to get coordinates";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromAddress(address); // Convert on startup
    _getCoordinatesFromAddress(address).then((value) {
      debugPrint(coordinates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address to Coordinates"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Address: $address",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              coordinates,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

