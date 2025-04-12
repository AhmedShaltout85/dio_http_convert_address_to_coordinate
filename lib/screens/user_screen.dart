// // ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_field

// import 'dart:async'; // Import Timer
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart';

// import 'package:pick_location/custom_widget/custom_browser_redirect.dart';
// import 'package:pick_location/screens/agora_video_call.dart';
// // import 'package:pick_location/screens/agora_video_call.dart';
// import 'package:pick_location/screens/integration_with_stores_get_all_qty.dart';
// import 'package:pick_location/screens/user_request_tools.dart';
// import 'package:pick_location/utils/dio_http_constants.dart';
// import '../custom_widget/custom_alert_dialog_with_sound.dart';
// import '../custom_widget/custom_web_view.dart';
// import '../network/remote/dio_network_repos.dart';

// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});

//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   late Future<List<Map<String, dynamic>>> getUsersBrokenPointsList;
//   Timer? _timer, _timer2; // Timer for periodic fetching
//   int? isApproved;
//   LocationData? currentLocation;
//   late String address;
//   String storeName = "";
//   int videoCall = 0;

//   StreamSubscription<LocationData>? locationSubscription;

//   @override
//   void initState() {
//     super.initState();

//     _fetchData(); // Initial fetch
//     _getCurrentLocation(); // Get current location
//     _startPeriodicFetch(); // Start periodic fetching
//     // _startFetchingLocation(); // Start fetching location every 1 minutes
//     // _updateUI(); // Update UI
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel periodic fetch and location update timer
//     locationSubscription?.cancel(); // Cancel location listener subscription
//     super.dispose();
//   }

//   // Function to fetch data
//   void _fetchData() {
//     if (!mounted) return;
// //
//     setState(() {
//       getUsersBrokenPointsList = DioNetworkRepos()
//           .fetchHandasatUsersItemsBroken(
//               DataStatic.handasahName, DataStatic.username, 0);
//     });
//     getUsersBrokenPointsList.then((value) {
//       debugPrint("PRINTED DATA FROM UI: $value");
//       if (value[0]['video_call'] == 1) {
//         _showDialog(context, value[0]['address']);
//         _timer2?.cancel();
//       } else if (value[0]['video_call'] == 0) {
//         _updateUI(); // Update UI
//       }
//       if (value.isEmpty) {
//         debugPrint("Data is empty, will retry...");
//       }
//     });
//   }

// // Function to get current location(with permission request)
//   Future<void> _getCurrentLocation() async {
//     var location = Location();
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//       // location.enableBackgroundMode(enable: true);
//     }

//     try {
//       var userLocation = await location.getLocation();
//       setState(() {
//         currentLocation = userLocation;
//       });
//     } catch (e) {
//       debugPrint("Error getting location: $e");
//     }

//     locationSubscription = //not tested
//         location.onLocationChanged.listen((LocationData newLocation) {
//       setState(() {
//         currentLocation = newLocation;
//       });
//     });
//   }

//   //Function to start fetching updated location
//   void _startFetchingLocation() {
//     const updateInterval = Duration(minutes: 1);
//     _timer = Timer.periodic(updateInterval, (Timer timer) {
//       DioNetworkRepos().updateLocationToBackend(
//           address, currentLocation!.latitude!, currentLocation!.longitude!);
//     });
//   }
//   // //Function to start fetching updated location
//   // void _startFetchingLocation() {
//   //   // _getCurrentLocation();
//   //   DioNetworkRepos().updateLocationToBackend(
//   //       address, currentLocation!.latitude!, currentLocation!.longitude!);
//   // }

//   // Function to start periodic fetching
//   void _startPeriodicFetch() {
//     const Duration fetchInterval = Duration(minutes: 1); // Fetch every 1 minute
//     _timer = Timer.periodic(fetchInterval, (Timer timer) {
//       getUsersBrokenPointsList.then((data) {
//         if (data.isEmpty) {
//           debugPrint("Data is empty, fetching again...");
//           _fetchData(); // Fetch data again if it's empty
//         }
//       });
//     });
//   }

//   //auto update ui
//   void _updateUI() {
//     const Duration fetchInterval =
//         Duration(seconds: 10); // Fetch every 10 seconds
//     _timer2 = Timer.periodic(fetchInterval, (Timer timer) {
//       _fetchData();
//     });
//   }

//   void _showDialog(BuildContext context, String address) {
//     showDialog(
//       context: context,
//       builder: (context) => CustomAlertDialogWithSound(
//         title: 'مكالمة فيديو واردة من الطورائ',
//         message: address,
//         soundPath: 'sounds/ringtone.mp3',
//         icon: Icons.videocam,
//         address: address,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '${DataStatic.username} : الاعطال المخصصة للمستخدم',
//           style: const TextStyle(color: Colors.white, fontSize: 15),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.indigo,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//       ),
//       body: FutureBuilder(
//           future: getUsersBrokenPointsList,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data!.isEmpty) {
//                 return const Center(
//                   child: Text("عفوا لايوجد شكاوى جديدة"),
//                 );
//               }
//               return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     address = snapshot.data![index]['address'];
//                     isApproved = snapshot.data![index]['is_approved'];
//                     videoCall = snapshot.data![index]['video_call'];
//                     return Card(
//                       margin: const EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           ListTile(
//                             title: Text(
//                               textAlign: TextAlign.center,
//                               snapshot.data![index]['address'],
//                               style: const TextStyle(
//                                   color: Colors.indigo,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15),
//                             ),
//                           ),
//                           snapshot.data![index]['handasah_name'] == null
//                               ? const SizedBox.shrink()
//                               : ListTile(
//                                   title: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           '${snapshot.data![index]['handasah_name']}',
//                                           style: const TextStyle(
//                                               color: Colors.green),
//                                         ),
//                                         Text(
//                                           '${snapshot.data![index]['technical_name']}',
//                                           style: const TextStyle(
//                                               color: Colors.green),
//                                         ),
//                                         isApproved == 0
//                                             ? TextButton(
//                                                 style: const ButtonStyle(
//                                                   backgroundColor:
//                                                       WidgetStatePropertyAll(
//                                                           Colors.orange),
//                                                 ),
//                                                 onPressed: () async {
//                                                   //update isApproved
//                                                   await DioNetworkRepos()
//                                                       .updateLocAddIsApproved(
//                                                           snapshot.data![index]
//                                                               ['address'],
//                                                           1);
//                                                   setState(() {
//                                                     isApproved = 1;
//                                                   });
//                                                   //fetch data
//                                                   _fetchData();

//                                                   // check if address already exist(UPDATED-IN-29-01-2025)
//                                                   var addressInList =
//                                                       await DioNetworkRepos()
//                                                           .checkAddressExistsInTracking(
//                                                               address);
//                                                   debugPrint(
//                                                       "PRINTED DATA FROM UI:  ${await DioNetworkRepos().checkAddressExistsInTracking(address)}");
//                                                   debugPrint(
//                                                       "PRINTED BY USING VAR: $addressInList");

//                                                   if (addressInList == true) {
//                                                     //  call the function to update locations in database
//                                                     debugPrint(
//                                                         "address already exist >>>>>> $addressInList");

//                                                     //  call the function to update locations in database
//                                                     await DioNetworkRepos()
//                                                         .updateTrackingLocations(
//                                                             address,
//                                                             double
//                                                                 .parse(snapshot
//                                                                             .data![
//                                                                         index]
//                                                                     [
//                                                                     'longitude']),
//                                                             double
//                                                                 .parse(snapshot
//                                                                             .data![
//                                                                         index]
//                                                                     [
//                                                                     'latitude']),
//                                                             currentLocation!
//                                                                 .latitude!,
//                                                             currentLocation!
//                                                                 .longitude!,
//                                                             currentLocation
//                                                                 ?.latitude,
//                                                             currentLocation
//                                                                 ?.longitude,
//                                                             snapshot.data![
//                                                                     index][
//                                                                 'technical_name']);
//                                                     // //updated Location
//                                                     _startFetchingLocation();
//                                                   } else {
//                                                     //post current user Location

//                                                     await DioNetworkRepos()
//                                                         .sendLocationToBackend(
//                                                             snapshot.data![index]
//                                                                 ['address'],
//                                                             snapshot.data![
//                                                                     index][
//                                                                 'technical_name'],
//                                                             double.parse(snapshot
//                                                                         .data![
//                                                                     index]
//                                                                 ['latitude']),
//                                                             double.parse(snapshot
//                                                                         .data![
//                                                                     index]
//                                                                 ['longitude']),
//                                                             currentLocation
//                                                                 ?.latitude,
//                                                             currentLocation
//                                                                 ?.longitude);
//                                                     debugPrint(
//                                                         'address: ${snapshot.data![index]['address']}, latitude: ${snapshot.data![index]['latitude']},longitude: ${snapshot.data![index]['longitude']},currentLocation?.latitude: ${currentLocation?.latitude},currentLocation?.longitude: ${currentLocation?.longitude}, technical_name: ${snapshot.data![index]['technical_name']}');

//                                                     debugPrint(
//                                                         'Updated status to approved and refreshed UI.');
//                                                     // //updated Location
//                                                     _startFetchingLocation();
//                                                   }
//                                                 },
//                                                 child: const Text(
//                                                   'قيد قبول الشكوى',
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 7),
//                                                 ),
//                                               )
//                                             : TextButton(
//                                                 style: const ButtonStyle(
//                                                   backgroundColor:
//                                                       WidgetStatePropertyAll(
//                                                           Colors.green),
//                                                 ),
//                                                 onPressed: () {
//                                                   //active live Location
//                                                 },
//                                                 child: const Text(
//                                                   'تم قبول الشكوى',
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 8),
//                                                 ),
//                                               )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                           ListTile(
//                             title: Text(
//                               'الاحداثئات :  ${snapshot.data![index]['latitude']} , ${snapshot.data![index]['longitude']}',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textDirection: TextDirection.rtl,
//                             ),
//                           ),
//                           ListTile(
//                             title: Text(
//                               'إسم المبلغ :  ${snapshot.data![index]['caller_name']}',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textDirection: TextDirection.rtl,
//                             ),
//                           ),
//                           ListTile(
//                             title: Text(
//                               ' رقم هاتف المبلغ:  ${snapshot.data![index]['caller_phone']}',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textDirection: TextDirection.rtl,
//                             ),
//                           ),
//                           ListTile(
//                             title: Text(
//                               'نوع الكسر :  ${snapshot.data![index]['broker_type']}',
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textDirection: TextDirection.rtl,
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                 tooltip: 'اظهار الموقع على الخريطة GIS Map',
//                                 hoverColor: Colors.yellow,
//                                 onPressed: () {
//                                   debugPrint(
//                                       "Start Gis Map ${snapshot.data![index]['gis_url']}");
//                                   if (kIsWeb) {
//                                     CustomBrowserRedirect.openInBrowser(
//                                         snapshot.data![index]['gis_url']);
//                                   } else {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => CustomWebView(
//                                           title:
//                                               '${snapshot.data![index]['address']}',
//                                           url: snapshot.data![index]['gis_url'],
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 icon: const Icon(
//                                   Icons.open_in_browser,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               IconButton(
//                                 tooltip: 'إجراء مكالمة فيديو',
//                                 hoverColor: Colors.yellow,
//                                 onPressed: () {
//                                   debugPrint(
//                                       "Start Video Call ${snapshot.data![index]['id']}");
//                                   if (snapshot.data![index]['video_call'] ==
//                                       0) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content: Text(
//                                         'لايمكن إجراء مكالمة فيديو قبل قبول تفعيل الاتصال من الطوارئ',
//                                         textDirection: TextDirection.rtl,
//                                         textAlign: TextAlign.center,
//                                       )),
//                                     );
//                                   } else {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => AgoraVideoCall(
//                                           title:
//                                               '${snapshot.data![index]['address']}',
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   // else if (snapshot.data![index]
//                                   //         ['video_call'] ==
//                                   //     1) {
//                                   //   _showDialog(context,
//                                   //       snapshot.data![index]['address']);
//                                   //   _timer2?.cancel();
//                                   // }
//                                 },
//                                 icon: const Icon(
//                                   Icons.video_call,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               IconButton(
//                                 tooltip: 'طلب مهمات مخازن',
//                                 hoverColor: Colors.yellow,
//                                 onPressed: () {
//                                   //
//                                    //navigate to requests tools screen
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                            UserRequestTools(
//                                             handasahName: snapshot.data![index]
//                                             ['handasah_name'] ?? DataStatic.handasahName,
//                                             address: snapshot.data![index]
//                                             ['address'],
//                                             technicianName: snapshot.data![index]
//                                             ['technical_name'],
//                                           ),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.local_convenience_store_outlined,
//                                   color: Colors.cyan,
//                                 ),
//                               ),
//                               IconButton(
//                                 tooltip: 'جرد مخزن',
//                                 hoverColor: Colors.yellow,
//                                 onPressed: () async {
//                                   //
//                                   //get store name by handasah
//                                   debugPrint(
//                                       "Store Name before get: $storeName");
//                                   debugPrint(
//                                       "Handasah Name before get: ${snapshot.data![index]['handasah_name']}");
//                                   await DioNetworkRepos()
//                                       .getStoreNameByHandasahName(snapshot
//                                           .data![index]['handasah_name'])
//                                       .then((value) {
//                                     // setState(() {
//                                     debugPrint(value['storeName']);
//                                     storeName = value['storeName'];
//                                     // });
//                                   });
//                                   debugPrint(
//                                       "Store Name after get: $storeName");
//                                   //excute tempStoredProcedure
//                                   DioNetworkRepos()
//                                       .excuteTempStoreQty(storeName);

//                                   //navigate to IntegrationWithStoresGetAllQty
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           IntegrationWithStoresGetAllQty(
//                                         storeName: storeName,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.store_outlined,
//                                   color: Colors.indigo,
//                                 ),
//                               ),
//                               IconButton(
//                                 tooltip: 'إغلاق الشكوى',
//                                 hoverColor: Colors.yellow,
//                                 onPressed: () {
//                                   setState(() {
//                                     // //stop live Location
//                                     // _stopFetchingLocation(); //not tested

//                                     //update is_finished(close broken locations)
//                                     DioNetworkRepos().updateLocAddIsFinished(
//                                         snapshot.data![index]['address'], 1);
//                                     //
//                                     DioNetworkRepos().fetchHandasatUsersItemsBroken(
//                                         DataStatic.handasahName,
//                                         DataStatic.username,
//                                         0); // Manually refresh data after update
//                                     snapshot.data!.removeAt(0);
//                                   });
//                                 },
//                                 icon: const Icon(
//                                   Icons.close_rounded,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text("Error: ${snapshot.error}"),
//               );
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//       // floatingActionButton: FloatingActionButton(
//       //   backgroundColor: Colors.cyan,
//       //   onPressed: () {
//       //     _fetchData(); // Manually refresh data
//       //   },
//       //   mini: true,
//       //   tooltip: 'تحديث',
//       //   child: const Icon(
//       //     Icons.refresh,
//       //     color: Colors.white,
//       //   ),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
//     );
//   }
// }
// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_field

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:pick_location/custom_widget/custom_browser_redirect.dart';
import 'package:pick_location/screens/agora_video_call.dart';
import 'package:pick_location/screens/integration_with_stores_get_all_qty.dart';
import 'package:pick_location/screens/user_request_tools.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import '../custom_widget/custom_alert_dialog_with_sound.dart';
import '../custom_widget/custom_web_view.dart';
import '../network/remote/dio_network_repos.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
 // Initialize with empty future instead of using 'late'
  Future<List<Map<String, dynamic>>> getUsersBrokenPointsList =
      Future.value([]);

  Timer? _timer, _timer2;
  int? isApproved;
  LocationData? currentLocation;
  String address = ""; // Initialize with empty string
  String storeName = "";
  int videoCall = 0;
  StreamSubscription<LocationData>? locationSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    // Initialize the future properly
    getUsersBrokenPointsList = _loadInitialData();
    _initializeData();
  }

  Future<List<Map<String, dynamic>>> _loadInitialData() async {
    return DioNetworkRepos().fetchHandasatUsersItemsBroken(
        DataStatic.handasahName, DataStatic.username, 0);
  }

  void _initializeData() async {
    await _getCurrentLocation();
    _fetchData();
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer2?.cancel();
    locationSubscription?.cancel();
    super.dispose();
  }

  void _fetchData() {
    if (_isDisposed) return;

    setState(() {
      getUsersBrokenPointsList = DioNetworkRepos()
          .fetchHandasatUsersItemsBroken(
              DataStatic.handasahName, DataStatic.username, 0);
    });

    getUsersBrokenPointsList.then((value) {
      if (_isDisposed) return;

      debugPrint("PRINTED DATA FROM UI: $value");

      if (value.isEmpty) {
        debugPrint("Data is empty, will retry...");
        return;
      }

      if (value[0]['video_call'] == 1) {
        _showDialog(context, value[0]['address']);
        _timer2?.cancel();
      } else if (value[0]['video_call'] == 0) {
        _startUIUpdateTimer();
      }
    }).catchError((error) {
      debugPrint("Error fetching data: $error");
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      var location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final userLocation = await location.getLocation();
      if (_isDisposed) return;

      setState(() {
        currentLocation = userLocation;
      });

      locationSubscription = location.onLocationChanged.listen((newLocation) {
        if (_isDisposed) return;
        setState(() {
          currentLocation = newLocation;
        });
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void _startPeriodicFetch() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      _fetchData();
    });
  }

  void _startUIUpdateTimer() {
    _timer2?.cancel();
    _timer2 = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      _fetchData();
    });
  }

  void _showDialog(BuildContext context, String address) {
    if (_isDisposed) return;

    showDialog(
      context: context,
      builder: (context) => CustomAlertDialogWithSound(
        title: 'مكالمة فيديو واردة من الطورائ',
        message: address,
        soundPath: 'sounds/ringtone.mp3',
        icon: Icons.videocam,
        address: address,
      ),
    );
  }

  Future<void> _handleApproval(Map<String, dynamic> item) async {
    try {
      await DioNetworkRepos().updateLocAddIsApproved(item['address'], 1);

      if (_isDisposed) return;

      setState(() {
        isApproved = 1;
      });

      _fetchData();

      final addressInList =
          await DioNetworkRepos().checkAddressExistsInTracking(item['address']);

      debugPrint("Address exists in tracking: $addressInList");

      if (addressInList == true) {
        await DioNetworkRepos().updateTrackingLocations(
          item['address'],
          double.parse(item['longitude']),
          double.parse(item['latitude']),
          currentLocation?.latitude ?? 0,
          currentLocation?.longitude ?? 0,
          currentLocation?.latitude,
          currentLocation?.longitude,
          item['technical_name'],
        );
      } else {
        await DioNetworkRepos().sendLocationToBackend(
          item['address'],
          item['technical_name'],
          double.parse(item['latitude']),
          double.parse(item['longitude']),
          currentLocation?.latitude,
          currentLocation?.longitude,
        );
      }

      // Start location updates
      _startLocationUpdates(item['address']);
    } catch (e) {
      debugPrint("Error in approval process: $e");
    }
  }

  void _startLocationUpdates(String address) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      if (currentLocation != null) {
        DioNetworkRepos().updateLocationToBackend(
            address, currentLocation!.latitude!, currentLocation!.longitude!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${DataStatic.username} : الاعطال المخصصة للمستخدم',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: getUsersBrokenPointsList,
        builder: (context, snapshot) {
          // Handle initial empty state
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("عفوا لايوجد شكاوى جديدة"));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("عفوا لايوجد شكاوى جديدة"));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              address = item['address'];
              isApproved = item['is_approved'];
              videoCall = item['video_call'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        item['address'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (item['handasah_name'] != null)
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['handasah_name'],
                                  style: const TextStyle(color: Colors.green)),
                              Text(item['technical_name'],
                                  style: const TextStyle(color: Colors.green)),
                              isApproved == 0
                                  ? TextButton(
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.orange),
                                      ),
                                      onPressed: () => _handleApproval(item),
                                      child: const Text(
                                        'قيد قبول الشكوى',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 7,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.green),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        'تم قبول الشكوى',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ListTile(
                      title: Text(
                        'الاحداثئات :  ${item['latitude']} , ${item['longitude']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'إسم المبلغ :  ${item['caller_name']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        ' رقم هاتف المبلغ:  ${item['caller_phone']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'نوع الكسر :  ${item['broker_type']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIconButton(
                          Icons.open_in_browser,
                          Colors.blue,
                          'اظهار الموقع على الخريطة GIS Map',
                          () => _openGisMap(item['gis_url'], item['address']),
                        ),
                        _buildIconButton(
                          Icons.video_call,
                          Colors.green,
                          'إجراء مكالمة فيديو',
                          () => _handleVideoCall(
                              item['video_call'], item['address']),
                        ),
                        _buildIconButton(
                          Icons.local_convenience_store_outlined,
                          Colors.cyan,
                          'طلب مهمات مخازن',
                          () => _navigateToRequestTools(item),
                        ),
                        _buildIconButton(
                          Icons.store_outlined,
                          Colors.indigo,
                          'جرد مخزن',
                          () => _handleInventory(item),
                        ),
                        _buildIconButton(
                          Icons.close_rounded,
                          Colors.red,
                          'إغلاق الشكوى',
                          () => _closeComplaint(item['address'], index),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIconButton(
      IconData icon, Color color, String tooltip, VoidCallback onPressed) {
    return IconButton(
      tooltip: tooltip,
      hoverColor: Colors.yellow,
      onPressed: onPressed,
      icon: Icon(icon, color: color),
    );
  }

  void _openGisMap(String url, String title) {
    debugPrint("Start Gis Map $url");
    if (kIsWeb) {
      CustomBrowserRedirect.openInBrowser(url);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomWebView(title: title, url: url),
        ),
      );
    }
  }

  void _handleVideoCall(int videoCallStatus, String address) {
    debugPrint("Start Video Call");
    if (videoCallStatus == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'لايمكن إجراء مكالمة فيديو قبل قبول تفعيل الاتصال من الطوارئ',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgoraVideoCall(title: address),
        ),
      );
    }
  }

  void _navigateToRequestTools(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserRequestTools(
          handasahName: item['handasah_name'] ?? DataStatic.handasahName,
          address: item['address'],
          technicianName: item['technical_name'],
        ),
      ),
    );
  }

  Future<void> _handleInventory(Map<String, dynamic> item) async {
    try {
      debugPrint("Store Name before get: $storeName");
      debugPrint("Handasah Name before get: ${item['handasah_name']}");

      final value = await DioNetworkRepos()
          .getStoreNameByHandasahName(item['handasah_name']);

      storeName = value['storeName'];

      debugPrint("Store Name after get: $storeName");

      await DioNetworkRepos().excuteTempStoreQty(storeName);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IntegrationWithStoresGetAllQty(
            storeName: storeName,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error handling inventory: $e");
    }
  }

  void _closeComplaint(String address, int index) {
    setState(() {
      DioNetworkRepos().updateLocAddIsFinished(address, 1);
      getUsersBrokenPointsList.then((list) {
        if (list.isNotEmpty && index < list.length) {
          list.removeAt(index);
        }
      });
    });
  }
}
