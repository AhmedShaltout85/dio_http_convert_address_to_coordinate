// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   // Check if location services are enabled
//   Future<bool> _checkLocationPermission() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return false;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return false;
//     }

//     return true;
//   }

//   // Get the current location
//   Future<Position?> getCurrentLocation() async {
//     bool hasPermission = await _checkLocationPermission();
//     if (!hasPermission) {
//       return null;
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   // Listen for location updates
//   Stream<Position> getLiveLocation() {
//     return Geolocator.getPositionStream();
//   }
// }
