// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// import '../custom_widget/custom_drawer.dart';
// import '../network/remote/dio_network_repos.dart';

// class AddressToCoordinatesOther extends StatefulWidget {
//   const AddressToCoordinatesOther({super.key});

//   @override
//   AddressToCoordinatesOtherState createState() =>
//       AddressToCoordinatesOtherState();
// }

// class AddressToCoordinatesOtherState extends State<AddressToCoordinatesOther> {
//   // String storeName = "";
//   final Completer<GoogleMapController> _controller = Completer();

//   String address = "";
//   String coordinates = "";
//   String getAddress = "";
//   LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
//   double latitude = 0.0, longitude = 0.0;
//   var pickMarkers = HashSet<Marker>();
//   late Future getAllHotLineAddresses; //get addresses from db(HotLine)

//   final TextEditingController addressController = TextEditingController();

//   // Replace with your actual Google Maps API key
//   String googleMapsApiKey = "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";
//   double fontSize = 12.0;
//   // Timer? _timer; // Timer for periodic fetching

//   @override
//   void dispose() {
//     // _timer?.cancel(); // Cancel periodic fetch and location update timer
//     // Dispose the controller when the widget is disposed
//     addressController.dispose();
//     super.dispose();
//   }

//   //update in periodic time
//   // void _startPeriodicFetch() {
//   //   const Duration fetchInterval =
//   //       Duration(seconds: 10); // Fetch every 10 seconds
//   //   _timer = Timer.periodic(fetchInterval, (Timer timer) {
//   //     setState(() {
//   //       getLocs = DioNetworkRepos().getLoc();
//   //       getLocsAfterGetCoordinatesAndGis =
//   //           DioNetworkRepos().getLocByFlagAndIsFinished();
//   //       getLocsByHandasahNameAndTechinicianName =
//   //           DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
//   //     });
//   //   });
//   // }

//   @override
//   void initState() {
//     super.initState();

//     setState(() {
//       // DioNetworkRepos().getHotLineTokenByUserAndPassword();
//       // getLocs = DioNetworkRepos().getHotLineData();
//       getAllHotLineAddresses = DioNetworkRepos().getHotlineAllAddress();
//     });

//     // DioNetworkRepos().getHotLineTokenByUserAndPassword().then((value) {
//     //   value['token'] = DataStatic.token;
//     //   debugPrint(value['token']);
//     //   debugPrint("PRINT TOKEN: ${DataStatic.token}");
//     // });
//     getAllHotLineAddresses.then(
//         (value) => debugPrint("GET ALL HOTlINE LOCATIONS FROM UI: $value"));
//     //
//     fetchData();
//     // DioNetworkRepos().postHotLineDataList(getLocs);
//   }

//   Future<void> fetchData() async {
//     // Mark function as `async`
//     // Assume this returns Future<List<Map<String, dynamic>>>
//     Future<List<Map<String, dynamic>>> getAllHotLineAddresses =
//         DioNetworkRepos().getHotlineAllAddress();

//     // Wait for the Future to complete
//     List<Map<String, dynamic>> hotLineAllDataList =
//         await getAllHotLineAddresses;
//     DioNetworkRepos().postHotLineDataList(hotLineAllDataList);

//     // Now use actualData where List<Map> is expected
//     debugPrint(hotLineAllDataList.toString());
//   }

//   // Function to get latitude and longitude from an address using Google Maps Geocoding API
//   Future<void> _getCoordinatesFromAddress(String address) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['results'].isNotEmpty) {
//           var location = data['results'][0]['geometry']['location'];
//           setState(() {
//             coordinates =
//                 "Latitude: ${location['lat']}, Longitude: ${location['lng']}";
//             latitude = location['lat']; // latitude
//             longitude = location['lng']; // longitude

//             //add marker
//             pickMarkers.add(
//               Marker(
//                 markerId: MarkerId(address),
//                 position: LatLng(latitude, longitude),
//                 infoWindow: InfoWindow(
//                   title: address,
//                   snippet: coordinates,
//                 ),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                     BitmapDescriptor.hueGreen),
//               ),
//             );
//             //
//             debugPrint(address);
//             debugPrint(coordinates);
//             debugPrint(longitude.toString());
//             debugPrint(latitude.toString());

//             //update locations after getting coordinates
//             getAllHotLineAddresses = DioNetworkRepos().getHotlineAllAddress();
//           });

//           //get last gis record from GIS server
//           int lastRecordNumber = await DioNetworkRepos()
//               .getLastRecordNumberWeb(); //get last gis record from GIS serverWEB-NO-BODY
//           debugPrint("lastRecordNumber :>> $lastRecordNumber");
//           int newRecordNumber = lastRecordNumber + 1;
//           debugPrint("newRecordNumber :>> $newRecordNumber");
//           //
//           //create new gis point
//           String mapLink =
//               await DioNetworkRepos().createNewGisPointAndGetMapLink(
//             newRecordNumber,
//             longitude.toString(),
//             latitude.toString(),
//           );
//           debugPrint("gis_longitude :>> $longitude");
//           debugPrint("gis_latitude :>> $latitude");
//           debugPrint("GIS MAP LINK :>> $mapLink");

//           // check if address already exist(UPDATED-IN-29-01-2025)
//           var addressInList =
//               await DioNetworkRepos().checkAddressExists(address);
//           debugPrint(
//               "PRINTED DATA FROM UI:  ${await DioNetworkRepos().checkAddressExists(address)}");
//           debugPrint("PRINTED BY USING VAR: $addressInList");
//           // debugPrint("PRINTED BY USING STRING: $addressInListString");
//           //
//           //
//           if (addressInList == true) {
//             //  call the function to update locations in database
//             debugPrint("address already exist >>>>>> $addressInList");

//             //  call the function to update locations in database
//             //update Locations list after getting coordinates and gis link
//             await DioNetworkRepos().updateLocations(
//               address,
//               longitude,
//               latitude,
//               mapLink,
//             );
//             //
//             debugPrint(
//                 "updated Locations list after getting coordinates and gis link");
//           } else {
//             //  call the function to post locations in database
//             debugPrint("address not exist >>>>>>>>> $addressInList");

//             //  call the function to post locations in database
//             await DioNetworkRepos().createNewLocation(
//               address,
//               longitude,
//               latitude,
//               mapLink,
//             );
//             //
//             debugPrint(
//                 "POSTED new Location In Locations list after getting coordinates and gis link");
//           }

//           //update Locations list after getting coordinates

//           setState(() {
//             getAllHotLineAddresses = DioNetworkRepos().getHotlineAllAddress();
//           });
//         } else {
//           setState(() {
//             coordinates = "Error: No results found";
//           });
//         }
//       } else {
//         setState(() {
//           coordinates = "Error: Failed to fetch data";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         coordinates = "Error: Unable to get coordinates";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "شكاوى خارجية",
//           style: TextStyle(color: Colors.indigo),
//         ),
//         centerTitle: true,
//         elevation: 7,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.indigo,
//           size: 17,
//         ),
//         //   actions: [
//         //     IconButton(
//         //       padding: const EdgeInsets.symmetric(horizontal: 5),
//         //       tooltip: "إضافة مستخدمين الطوارئ",
//         //       hoverColor: Colors.yellow,
//         //       icon: const Icon(
//         //         Icons.person_add_alt,
//         //         color: Colors.indigo,
//         //       ),
//         //       onPressed: () {
//         //         //
//         //         showDialog(
//         //             context: context,
//         //             builder: (context) {
//         //               return CustomReusableAlertDialog(
//         //                   title: 'اضافة مستخدمين الطوارئ',
//         //                   fieldLabels: const [
//         //                     'اسم المستخدم',
//         //                     'كلمة المرور',
//         //                     'مطابقة كلمة المرور',
//         //                   ],
//         //                   onSubmit: (values) {
//         //                     DioNetworkRepos().createNewUser(
//         //                         values[0], values[1], 1, 'غرفة الطوارئ');
//         //                   });
//         //             });
//         //         debugPrint(
//         //             "User Input: updated Caller Name, Phone, And Borken Number");
//         //       },
//         //     ),
//         //     TextButtonDropdown(
//         //       label: 'التقارير',
//         //       options: const [
//         //         'عرض التقارير',
//         //         'الربط مع الاسكادا',
//         //         'عرض المناطق المزدحمة بالبلاغات'
//         //       ],
//         //       onSelected: handleOptionClick,
//         //     ),
//         //   ],
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Stack(
//                 children: [
//                   GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: alexandriaCoordinates,
//                       zoom: 10.4746,
//                     ),
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                     markers: pickMarkers,
//                     zoomControlsEnabled: true,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             decoration: const InputDecoration(
//                               constraints: BoxConstraints(
//                                 maxHeight: 70,
//                                 minWidth: 200,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10.0),
//                                 ),
//                               ),
//                               hintText: "فضلا أدخل العنوان",
//                               hintStyle: TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             controller:
//                                 addressController, // set the controller to get address input
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.indigo,
//                             ),
//                             cursorColor: Colors.amber,
//                             keyboardType: TextInputType.text,
//                             maxLength: 250, textAlign: TextAlign.right,
//                             textDirection: TextDirection.rtl,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 17.0),
//                           child: IconButton(
//                             alignment: Alignment.center,
//                             onPressed: () async {
//                               if (addressController.text.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       "فضلا أدخل العنوان",
//                                       textDirection: TextDirection.rtl,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 );
//                               }
//                               setState(() {
//                                 pickMarkers.clear();
//                                 address = addressController.text;
//                                 _getCoordinatesFromAddress(address);
//                                 debugPrint(address);
//                                 addressController.clear();
//                                 //update locations after getting coordinates
//                                 getAllHotLineAddresses =
//                                     DioNetworkRepos().getHotlineAllAddress();
//                               });
//                             },
//                             icon: const CircleAvatar(
//                               backgroundColor: Colors.indigo,
//                               radius: 20,
//                               child: Icon(
//                                 Icons.search_outlined,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       drawer: CustomDrawer(
//         title: 'الاعطال الواردة من الخط الساخن',
//         getLocs: getAllHotLineAddresses,
//       ),
//     );
//   }
// }

// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// import '../custom_widget/custom_drawer.dart';
// import '../network/remote/dio_network_repos.dart';

// class AddressToCoordinatesOther extends StatefulWidget {
//   const AddressToCoordinatesOther({super.key});

//   @override
//   AddressToCoordinatesOtherState createState() =>
//       AddressToCoordinatesOtherState();
// }

// class AddressToCoordinatesOtherState extends State<AddressToCoordinatesOther> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final TextEditingController addressController = TextEditingController();

//   String address = "";
//   String coordinates = "";
//   LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
//   double latitude = 0.0, longitude = 0.0;
//   var pickMarkers = HashSet<Marker>();
//   late Future<List<Map<String, dynamic>>> getAllHotLineAddresses;
//   late Future<List<Map<String, dynamic>>> getAllHotLineAddressesFromOutSide;
//   List<Map<String, dynamic>> getAllhotLineAddressesListOutSide = [];

//   // Note: This API key should be secured and not hardcoded in production
//   static const String googleMapsApiKey =
//       "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";
//   String gettenToken = "";

//   @override
//   void dispose() {
//     addressController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadToken();
//     _initializeData();
//   }

//   Future<void> loadToken() async {
//     DioNetworkRepos().getHotLineTokenByUserAndPassword().then((token) {
//       debugPrint("GET HOTLINE TOKEN FROM UI: $token");
//      getAllHotLineAddressesFromOutSide = DioNetworkRepos().getHotLineData(token);

//       debugPrint(
//           "GET HOTLINE GETTEN List FROM UI: $getAllHotLineAddressesFromOutSide");
//     });
//         await DioNetworkRepos().postHotLineDataList(getAllHotLineAddressesFromOutSide);

//   }

//   Future<void> _initializeData() async {
//     try {
//       setState(() {
//         getAllHotLineAddresses = DioNetworkRepos().getHotlineAllAddress();
//       });

//       final addresses = await getAllHotLineAddresses;
//       debugPrint("GET ALL HOTLINE LOCATIONS FROM UI: $addresses");

//       await fetchData();
//     } catch (e) {
//       debugPrint("Error initializing data: $e");
//     }
//   }

//   Future<void> fetchData() async {
//     try {
//       final hotLineAllDataList = await DioNetworkRepos().getHotlineAllAddress();
//       debugPrint(hotLineAllDataList.toString());
//     } catch (e) {
//       debugPrint("Error fetching data: $e");
//     }
//   }

//   Future<void> _getCoordinatesFromAddress(String address) async {
//     if (address.isEmpty) return;

//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode != 200) {
//         setState(() {
//           coordinates = "Error: Failed to fetch data (${response.statusCode})";
//         });
//         return;
//       }

//       final data = json.decode(response.body);

//       if (data['results'].isEmpty) {
//         setState(() {
//           coordinates = "Error: No results found";
//         });
//         return;
//       }

//       final location = data['results'][0]['geometry']['location'];
//       final lat = location['lat'];
//       final lng = location['lng'];

//       setState(() {
//         coordinates = "Latitude: $lat, Longitude: $lng";
//         latitude = lat;
//         longitude = lng;

//         pickMarkers.add(
//           Marker(
//             markerId: MarkerId(address),
//             position: LatLng(latitude, longitude),
//             infoWindow: InfoWindow(
//               title: address,
//               snippet: coordinates,
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueGreen,
//             ),
//           ),
//         );

//         getAllHotLineAddresses = DioNetworkRepos().getHotlineAllAddress();
//       });

//       debugPrint("Address: $address");
//       debugPrint("Coordinates: $coordinates");
//       debugPrint("Longitude: $longitude");
//       debugPrint("Latitude: $latitude");

//       await _processGisData(address, lat, lng);
//     } catch (e) {
//       setState(() {
//         coordinates = "Error: Unable to get coordinates";
//       });
//       debugPrint("Error getting coordinates: $e");
//     }
//   }

//   Future<void> _processGisData(String address, double lat, double lng) async {
//     try {
//       final lastRecordNumber = await DioNetworkRepos().getLastRecordNumberWeb();
//       debugPrint("lastRecordNumber: $lastRecordNumber");

//       final newRecordNumber = lastRecordNumber + 1;
//       debugPrint("newRecordNumber: $newRecordNumber");

//       final mapLink = await DioNetworkRepos().createNewGisPointAndGetMapLink(
//         newRecordNumber,
//         lng.toString(),
//         lat.toString(),
//       );

//       debugPrint("GIS longitude: $longitude");
//       debugPrint("GIS latitude: $latitude");
//       debugPrint("GIS MAP LINK: $mapLink");

//       final addressExists = await DioNetworkRepos().checkAddressExists(address);
//       debugPrint("Address exists: $addressExists");

//       if (addressExists) {
//         debugPrint("Address already exists: $address");
//         await DioNetworkRepos().updateLocations(
//           address,
//           longitude,
//           latitude,
//           mapLink,
//         );
//         debugPrint("Updated existing location");
//       } else {
//         debugPrint("Address does not exist: $address");
//         await DioNetworkRepos().createNewLocation(
//           address,
//           longitude,
//           latitude,
//           mapLink,
//         );
//         debugPrint("Created new location");
//       }

//       setState(() {
//         getAllHotLineAddresses = DioNetworkRepos().getHotlineAllAddress();
//       });
//     } catch (e) {
//       debugPrint("Error processing GIS data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "شكاوى خارجية",
//           style: TextStyle(color: Colors.indigo),
//         ),
//         centerTitle: true,
//         elevation: 7,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.indigo,
//           size: 17,
//         ),
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Stack(
//                 children: [
//                   GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: alexandriaCoordinates,
//                       zoom: 10.4746,
//                     ),
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                     markers: pickMarkers,
//                     zoomControlsEnabled: true,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             decoration: const InputDecoration(
//                               constraints: BoxConstraints(
//                                 maxHeight: 70,
//                                 minWidth: 200,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10.0),
//                                 ),
//                               ),
//                               hintText: "فضلا أدخل العنوان",
//                               hintStyle: TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 11,
//                               ),
//                             ),
//                             controller: addressController,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.indigo,
//                             ),
//                             cursorColor: Colors.amber,
//                             keyboardType: TextInputType.text,
//                             maxLength: 250,
//                             textAlign: TextAlign.right,
//                             textDirection: TextDirection.rtl,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 17.0),
//                           child: IconButton(
//                             alignment: Alignment.center,
//                             onPressed: () async {
//                               if (addressController.text.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       "فضلا أدخل العنوان",
//                                       textDirection: TextDirection.rtl,
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 );
//                                 return;
//                               }

//                               setState(() {
//                                 pickMarkers.clear();
//                                 address = addressController.text;
//                                 addressController.clear();
//                               });

//                               await _getCoordinatesFromAddress(address);
//                             },
//                             icon: const CircleAvatar(
//                               backgroundColor: Colors.indigo,
//                               radius: 20,
//                               child: Icon(
//                                 Icons.search_outlined,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       drawer: CustomDrawer(
//         title: 'الاعطال الواردة من الخط الساخن',
//         getLocs: getAllHotLineAddresses,
//       ),
//     );
//   }
// }
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../custom_widget/custom_drawer.dart';
import '../network/remote/dio_network_repos.dart';

class AddressToCoordinatesOther extends StatefulWidget {
  const AddressToCoordinatesOther({super.key});

  @override
  AddressToCoordinatesOtherState createState() =>
      AddressToCoordinatesOtherState();
}

class AddressToCoordinatesOtherState extends State<AddressToCoordinatesOther> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController addressController = TextEditingController();

  String coordinates = "";
  LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
  double latitude = 0.0, longitude = 0.0;
  var pickMarkers = HashSet<Marker>();
  late Future<List<Map<String, dynamic>>> getAllHotLineAddresses;
  bool isLoading = false;

  // Load this from secure storage or environment variables
  static const String googleMapsApiKey =
      "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";
  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        getAllHotLineAddresses = _loadHotlineData();
      });
    } catch (e) {
      debugPrint("Error initializing app: $e");
      _showErrorSnackbar("Failed to initialize application");
    }
  }

  Future<List<Map<String, dynamic>>> _loadHotlineData() async {
    try {
      final token = await DioNetworkRepos().getHotLineTokenByUserAndPassword();
      return DioNetworkRepos().getHotLineData(token);
    } catch (e) {
      debugPrint("Error loading hotline data: $e");
      _showErrorSnackbar("Failed to load hotline data");
      return [];
    }
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    if (address.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch data (${response.statusCode})");
      }

      final data = json.decode(response.body);

      if (data['results'].isEmpty) {
        throw Exception("No results found for this address");
      }

      final location = data['results'][0]['geometry']['location'];
      final lat = location['lat'] as double;
      final lng = location['lng'] as double;

      await _updateMapWithNewLocation(address, lat, lng);
      await _processGisData(address, lat, lng);

      // Refresh data after update
      setState(() {
        getAllHotLineAddresses = _loadHotlineData();
      });
    } catch (e) {
      _showErrorSnackbar("Error: ${e.toString()}");
      debugPrint("Error getting coordinates: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateMapWithNewLocation(
      String address, double lat, double lng) async {
    setState(() {
      coordinates = "Latitude: $lat, Longitude: $lng";
      latitude = lat;
      longitude = lng;

      pickMarkers.clear();
      pickMarkers.add(
        Marker(
          markerId: MarkerId(address),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: address,
            snippet: coordinates,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    });

    // Move camera to new location
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(lat, lng)),
    );
  }

  Future<void> _processGisData(String address, double lat, double lng) async {
    try {
      final lastRecordNumber = await DioNetworkRepos().getLastRecordNumberWeb();
      final newRecordNumber = lastRecordNumber + 1;

      final mapLink = await DioNetworkRepos().createNewGisPointAndGetMapLink(
        newRecordNumber,
        lng.toString(),
        lat.toString(),
      );

      final addressExists = await DioNetworkRepos().checkAddressExists(address);

      if (addressExists) {
        await DioNetworkRepos().updateLocations(
          address,
          lng,
          lat,
          mapLink,
        );
      } else {
        await DioNetworkRepos().createNewLocation(
          address,
          lng,
          lat,
          mapLink,
        );
      }
    } catch (e) {
      debugPrint("Error processing GIS data: $e");
      rethrow;
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "شكاوى خارجية",
          style: TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.indigo,
          size: 17,
        ),
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
            },
            markers: pickMarkers,
            zoomControlsEnabled: true,
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
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
                          hintText: "فضلا أدخل العنوان",
                          hintStyle: TextStyle(
                            color: Colors.indigo,
                            fontSize: 11,
                          ),
                        ),
                        controller: addressController,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.indigo,
                        ),
                        cursorColor: Colors.amber,
                        keyboardType: TextInputType.text,
                        maxLength: 250,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 17.0),
                      child: IconButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (addressController.text.isEmpty) {
                                  _showErrorSnackbar("فضلا أدخل العنوان");
                                  return;
                                }

                                await _getCoordinatesFromAddress(
                                    addressController.text);
                              },
                        icon: CircleAvatar(
                          backgroundColor:
                              isLoading ? Colors.grey : Colors.indigo,
                          radius: 20,
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.search_outlined,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (coordinates.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      coordinates,
                      style: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        title: 'الاعطال الواردة من الخط الساخن',
        getLocs: getAllHotLineAddresses,
      ),
    );
  }
}
