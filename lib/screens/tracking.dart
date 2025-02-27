import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Tracking extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String address;
  const Tracking(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.address});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  GoogleMapController? mapController;
  LocationData? currentLocation;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  final String googleMapsApiKey =
      "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk"; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    
    //   var location = Location();

    //   try {
    //     var userLocation = await location.getLocation();
    //     setState(() {
    //       currentLocation = userLocation;
    //       markers.add(
    //         Marker(
    //           markerId: const MarkerId("current_location"),
    //           position: LatLng(userLocation.latitude!, userLocation.longitude!),
    //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //         ),
    //       );
    //     });
    //   } catch (e) {
    //     debugPrint("Error getting location: $e");
  }

  //   location.onLocationChanged.listen((LocationData newLocation) {
  //     setState(() {
  //       currentLocation = newLocation;
  //     });
  //   });
  // }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _addDestinationMarker(LatLng point) {
    point =LatLng(widget.latitude as double, widget.longitude as double);
    setState(() {
      markers.add(
        Marker(
          markerId:  MarkerId(widget.address),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
        title: const Text(
          'Tracking',
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    widget.latitude as double, widget.longitude as double),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(widget.address),
                  position: LatLng(
                      widget.latitude as double, widget.longitude as double),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
                Marker(
                  markerId: const MarkerId("current_location"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                )
              },
              polylines: polylines,
              onTap: _addDestinationMarker,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
