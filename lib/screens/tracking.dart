import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:pick_location/network/remote/dio_network_repos.dart';
import 'package:pick_location/utils/dio_http_constants.dart';

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
  // LocationData? currentLocation;
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double startLatitude = 0.0;
  double startLongitude = 0.0;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  final String googleMapsApiKey =
      "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk"; // Replace with your API key
  late Future getCurrentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    getCurrentLocation = DioNetworkRepos()
        .getLocationByAddressAndTechnician(widget.address, DataStatic.username);
    getCurrentLocation.then((value) {
      setState(() {
        currentLatitude = value[0]['currentLatitude'];
        currentLongitude = value[0]['currentLongitude'];
        startLatitude = value[0]['startLatitude'];
        startLongitude = value[0]['startLongitude'];
      });

    });

  
  }



  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _addDestinationMarker(LatLng point) {
    point = LatLng(double.parse(widget.latitude), double.parse(widget.longitude));
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(widget.address),
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
      body:
      //  startLatitude == 0 || startLongitude == 0
      //     ? const Center(child: CircularProgressIndicator())
      //     :
           GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                   double.parse( widget.latitude),double.parse(widget.longitude)),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(widget.address),
                  position: LatLng(
                      double.parse( widget.latitude),double.parse(widget.longitude)),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
                Marker(
                  markerId: const MarkerId("الموقع الحالى"),
                  position: LatLng(
                      currentLatitude, currentLongitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange),
                ),
                Marker(
                  markerId: const MarkerId("موقع بداية التتبع"),
                  position: LatLng(
                      startLatitude, startLongitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                )
              },
              polylines: polylines,
              onTap: _addDestinationMarker,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLatitude != 0.0 && currentLongitude != 0.0) {
            mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(currentLatitude, currentLongitude),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
