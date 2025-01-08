import 'dart:async';
import 'dart:collection';

import 'package:pick_location/custom_widget/custom_drawer.dart';
import 'package:pick_location/network/remote/dio_network_repos.dart';
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
  late Future getLocs;
  final TextEditingController addressController = TextEditingController();
  // List<LocationsMarkerModel> addressList = [];

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocs = DioNetworkRepos().getLoc();
    });
    getLocs.then((value) => debugPrint(value.toString()));

    // _getCoordinatesFromAddress(address); // Convert on startup

    // getLocs = DioNetworkRepos().getLoc();

    // getLocs.then((value) => debugPrint("FUTUTRE: $value[0].['address']"));

    // getLocs.then((value) {
    // if (value.isEmpty) {
    //   return Timer(
    //     const Duration(seconds: 10),
    //     () => getLocs = DioNetworkRepos().getLoc(),
    //   );
    // }
    //   value.forEach((element) {
    //     address = element['address'];
    //     _getCoordinatesFromAddress(address);
    //   });
    // }).catchError((e) {
    //   return e + "List is empty";
    // });

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

        // addressList.add(
        //   LocationsMarkerModel(
        //       address: address, latitude: latitude, longitude: longitude),
        // );
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
        // //
        // // call the function to update locations in database
        // DioNetworkRepos().updateLoc(address, latitude, longitude);
        // //update Locations list after getting coordinates
        // getLocs =  DioNetworkRepos().getLoc();
        // //
        debugPrint(address);
        debugPrint(coordinates);
        debugPrint(latitude.toString());
        debugPrint(longitude.toString());
        //
      });
      //  call the function to update locations in database
      DioNetworkRepos().updateLoc(address, latitude, longitude);

      // //update Locations list after getting coordinates

      setState(() {
        getLocs = DioNetworkRepos().getLoc();
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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: alexandriaCoordinates,
              zoom: 10.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 70,
                        minWidth: 200,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: "Enter Address",
                      hintStyle: TextStyle(
                        color: Colors.indigo,
                        fontSize: 11,
                      ),
                    ),
                    controller:
                        addressController, // set the controller to get address input
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.indigo,
                    ),
                    cursorColor: Colors.amber,
                    keyboardType: TextInputType.text,
                    maxLength: 250,
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints.tightFor(
                    width: 20,
                    height: 50,
                  ),
                  onPressed: () async {
                    if (addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Please enter address"),
                          backgroundColor: Colors.indigo.shade300,
                        ),
                      );
                    }
                    setState(() {
                      pickMarkers.clear();
                    });
                    address = addressController.text;
                    _getCoordinatesFromAddress(address);

                    //CALL GIS API to get map link
                    String mapLink =
                        await DioNetworkRepos().createNewGisPointAndGetMapLink(
                      13,
                      latitude.toString(),
                      longitude.toString(),
                    );
                    debugPrint("GIS MAP LINK :>> $mapLink");

                    //update Locations list after getting coordinates and url
                    // _getCoordinatesFromAddress(address);
                   await DioNetworkRepos().updateLocations(
                      address,
                      latitude,
                      longitude,
                      mapLink,
                    );

                    //
                    addressController.clear();
                  },
                  icon: const Icon(
                    Icons.search_outlined,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      drawer: CustomDrawer(
        getLocs: getLocs,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          // pickMarkers.clear();
          setState(() {
            getLocs = DioNetworkRepos().getLoc();
            // _getCoordinatesFromAddress(address);
          });
        },
        mini: true,
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

// Retrieve the copied text from the clipboard
// ClipboardData? data = await Clipboard.getData('text/plain');
// // Paste the text into the TextField
// if (data != null && data.text != null) {
//   debugPrint("Pasted text: ${data.text}");
// }
