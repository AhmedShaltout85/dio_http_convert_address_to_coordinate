import 'dart:async';
import 'dart:collection';

import 'package:dio_http/custom_widget/custom_drawer.dart';
// import 'package:dio_http/custom_widget/custom_map.dart';
import 'package:dio_http/network/remote/dio_network_repos.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressToCoordinates extends StatefulWidget {
  const AddressToCoordinates({super.key});

  @override
  AddressToCoordinatesState createState() => AddressToCoordinatesState();
}

class AddressToCoordinatesState extends State<AddressToCoordinates> {
  //declare vars
  final Completer<GoogleMapController> _controller = Completer();
  String address = "";
  String coordinates = "";
  LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
  double latitude = 0.0, longitude = 0.0;
  var pickMarkers = HashSet<Marker>();
  // final List<Marker> markers = <Marker>[];
  late Future getLocs;

  @override
  void initState() {
    super.initState();

    getLocs = DioNetworkRepos().getLoc();
    getLocs.then((value) => debugPrint("FUTUTRE: $value[0].['address']"));

    getLocs.then((value) => debugPrint(value.toString()));
    // getLocs = UsersDioRepos().getUsers();

    getLocs.then((value) {
      value.forEach((element) {
        address = element['address'];
        _getCoordinatesFromAddress(address);
    
      });
    });

    // _getCoordinatesFromAddress(address); // Convert on startup
    // debugPrint(address);
  }

// Function to get latitude and longitude from an address using Google Geocoding API
  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      setState(() {
        coordinates =
            "${locations.first.latitude}, ${locations.first.longitude}";
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
        //
         pickMarkers.add(
          Marker(
            markerId: MarkerId(address),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: address,
              snippet: coordinates,
            ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
          ),
        );
       //
     // call the function to update locations in database
        DioNetworkRepos().updateLoc(address, latitude, longitude);
        //
        debugPrint(address);
        debugPrint(coordinates);
        debugPrint(latitude.toString());
        debugPrint(longitude.toString());
        //

      });
    } catch (e) {
      setState(() {
        coordinates = "Error: Unable to get coordinates";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Address to Coordinates",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: alexandriaCoordinates,
              zoom: 11.4746,
            ),
            onMapCreated:
                (GoogleMapController controller) {
              _controller.complete(controller);
              setState(
                () {
                  
                  // pickMarkers.add(
                  //   Marker(
                  //     markerId: MarkerId(coordinates),
                  //     position: LatLng(latitude, longitude),
                  //     icon: BitmapDescriptor.defaultMarkerWithHue(
                  //         BitmapDescriptor.hueGreen),
                  //     infoWindow: InfoWindow(
                  //       title: address,
                  //       snippet: coordinates,
                  //     ),
                  //   ),
                  // );
                },
              );
            },
            markers: pickMarkers,
            zoomControlsEnabled: true,
          ),
        ],
      ),
      drawer: CustomDrawer(getLocs: getLocs),
    );
  }
}
