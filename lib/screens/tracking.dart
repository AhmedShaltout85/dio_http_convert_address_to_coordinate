// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pick_location/network/remote/dio_network_repos.dart';

class Tracking extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String address;
  final String technicianName;
  const Tracking({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.technicianName,
  });

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  Timer? _timer; // Timer for periodic fetching
  final Completer<GoogleMapController> _controller = Completer();
  LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double startLatitude = 0.0;
  double startLongitude = 0.0;
  final Set<Marker> markers = {};
  final String googleMapsApiKey =
      "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk"; // Replace with your API key
  late Future getCurrentLocation;
  Polyline _addPolyline() {
    LatLng end =
        LatLng(double.parse(widget.latitude), double.parse(widget.longitude));
    LatLng current = LatLng(currentLatitude, currentLongitude);
    LatLng start = LatLng(startLatitude, startLongitude);

    return Polyline(
      polylineId: const PolylineId('polyline'),
      points: [start, current, end],
      color: Colors.blue,
      width: 5,
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startFetchingLocation();
  }

  Future<void> _getCurrentLocation() async {
    debugPrint(widget.address);
    debugPrint(widget.technicianName);

    getCurrentLocation = DioNetworkRepos().getLocationByAddressAndTechnician(
        widget.address, widget.technicianName);

    getCurrentLocation.then((value) {
      debugPrint("print from ui: in Location Tracking $value");
      debugPrint("ID: ${value['id']}");
      debugPrint("Address: ${value['address']}");
      debugPrint("Latitude: ${value['latitude']}");
      debugPrint("Longitude: ${value['longitude']}");
      debugPrint("Technical Name: ${value['technicalName']}");
      debugPrint("Start Latitude: ${value['startLatitude']}");
      debugPrint("Start Longitude: ${value['startLongitude']}");
      debugPrint("Current Latitude: ${value['currentLatitude']}");
      debugPrint("Current Longitude: ${value['currentLongitude']}");
      setState(() {
        currentLatitude = double.parse(value['currentLatitude']);
        currentLongitude = double.parse(value['currentLongitude']);
        startLatitude = double.parse(value['startLatitude']);
        startLongitude = double.parse(value['startLongitude']);
      });
    });
  }

  //Function to start fetching updated location
  void _startFetchingLocation() {
    const updateInterval = Duration(minutes: 1);
    _timer = Timer.periodic(updateInterval, (Timer timer) {
      _getCurrentLocation();
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
        title: Text(
          'تتبع عنوان : ${widget.address}',
          style: const TextStyle(
            color: Colors.indigo,
          ),
        ),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: alexandriaCoordinates,
          zoom: 10.4746,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.address),
            position: LatLng(
                double.parse(widget.latitude), double.parse(widget.longitude)),
            infoWindow: InfoWindow(
                title: widget.address,
                snippet: "${widget.latitude}, ${widget.longitude}"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
          Marker(
            markerId: const MarkerId("الموقع الحالى"),
            position: LatLng(currentLatitude, currentLongitude),
            infoWindow: InfoWindow(
                title: "الموقع الحالى",
                // title: widget.address,
                snippet: "$currentLatitude, $currentLongitude"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ),
          Marker(
            markerId: const MarkerId("موقع بداية التتبع"),
            position: LatLng(startLatitude, startLongitude),
            infoWindow: InfoWindow(
                title: "موقع بداية التتبع",
                // title: widget.address,
                snippet: "$startLatitude, $startLongitude"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          )
        },
        polylines: {
          _addPolyline(),
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          _getCurrentLocation();
          if (currentLatitude != 0.0 && currentLongitude != 0.0) {
            _controller.future.then((controller) => controller.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(currentLatitude, currentLongitude),
                  ),
                ));
          }
        },
        mini: true,
        heroTag: "currentLocation",
        tooltip: "تحديد الموقع الحالى",
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
