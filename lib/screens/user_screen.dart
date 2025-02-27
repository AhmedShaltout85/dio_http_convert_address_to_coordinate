import 'dart:async'; // Import Timer
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:pick_location/custom_widget/custom_browser_redirect.dart';
import 'package:pick_location/screens/agora_video_call.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import '../custom_widget/custom_web_view.dart';
import '../network/remote/dio_network_repos.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<Map<String, dynamic>>> getUsersBrokenPointsList;
  Timer? _timer; // Timer for periodic fetching
  int? isApproved;
  LocationData? currentLocation;
  late String address;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial fetch
    _startPeriodicFetch(); // Start periodic fetching
    _getCurrentLocation(); // Get current location
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Function to fetch data
  void _fetchData() {
    setState(() {
      getUsersBrokenPointsList = DioNetworkRepos()
          .fetchHandasatUsersItemsBroken(
              DataStatic.handasahName, DataStatic.username, 0);
      // .fetchHandasatUsersItemsBroken('handasah', 'user', 0);
    });
    getUsersBrokenPointsList.then((value) {
      debugPrint("PRINTED DATA FROM UI: $value");
      if (value.isEmpty) {
        debugPrint("Data is empty, will retry...");
      }
    });
  }

// Function to get current location
  Future<void> _getCurrentLocation() async {
    var location = Location();

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
        // markers.add(
        //   Marker(
        //     markerId: const MarkerId("current_location"),
        //     position: LatLng(userLocation.latitude!, userLocation.longitude!),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        //   ),
        // );
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }

    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  //Function to start fetching updated location
  void _startFetchingLocation() {
    _getCurrentLocation();
    DioNetworkRepos().updateLocationToBackend(
        address, currentLocation!.latitude!, currentLocation!.longitude!);
  }

  // Function to start periodic fetching
  void _startPeriodicFetch() {
    const Duration fetchInterval =
        Duration(seconds: 10); // Fetch every 10 seconds
    _timer = Timer.periodic(fetchInterval, (Timer timer) {
      getUsersBrokenPointsList.then((data) {
        if (data.isEmpty) {
          debugPrint("Data is empty, fetching again...");
          _fetchData(); // Fetch data again if it's empty
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${DataStatic.username} : الاعطال المخصصة للمستخدم',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: FutureBuilder(
          future: getUsersBrokenPointsList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("عفوا لايوجد شكاوى جديدة"),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    isApproved = snapshot.data![index]['is_approved'];
                    address = snapshot.data![index]['address'];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              snapshot.data![index]['address'],
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          snapshot.data![index]['handasah_name'] == null
                              ? const SizedBox.shrink()
                              : ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${snapshot.data![index]['handasah_name']}',
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                        Text(
                                          '${snapshot.data![index]['technical_name']}',
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                        isApproved == 0
                                            ? TextButton(
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          Colors.orange),
                                                ),
                                                onPressed: () {
                                                  //update isApproved
                                                  setState(() {
                                                    DioNetworkRepos()
                                                        .updateLocAddIsApproved(
                                                            snapshot.data![
                                                                    index]
                                                                ['address'],
                                                            1);
                                                    isApproved = 1;
                                                    //fetch data
                                                    DioNetworkRepos()
                                                        .fetchHandasatUsersItemsBroken(
                                                            DataStatic
                                                                .handasahName,
                                                            DataStatic.username,
                                                            0);
                                                  });
                                                },
                                                child: const Text(
                                                  'قيد قبول الشكوى',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 7),
                                                ),
                                              )
                                            : TextButton(
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          Colors.green),
                                                ),
                                                onPressed: () {
                                                  //active live Location

                                                  setState(() {
                                                    //post current user Location
                                                    DioNetworkRepos()
                                                        .sendLocationToBackend(
                                                            snapshot.data![
                                                                    index]
                                                                ['address'],
                                                            snapshot.data![
                                                                    index][
                                                                'technical_name'],
                                                            snapshot.data![
                                                                    index]
                                                                ['latitude'],
                                                            snapshot.data![
                                                                    index]
                                                                ['longitude'],
                                                            currentLocation
                                                                ?.latitude,
                                                            currentLocation
                                                                ?.longitude);
                                                  });
                                                  debugPrint(
                                                      'address: ${snapshot.data![index]['address']}, latitude: ${snapshot.data![index]['latitude']},longitude: ${snapshot.data![index]['longitude']},currentLocation?.latitude: ${currentLocation?.latitude},currentLocation?.longitude: ${currentLocation?.longitude}, technical_name: ${snapshot.data![index]['technical_name']}');
                                                  //updated Location
                                                  _startFetchingLocation();
                                                },
                                                child: const Text(
                                                  'تم قبول الشكوى',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 7),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                tooltip: 'اظهار الموقع على الخريطة GIS Map',
                                hoverColor: Colors.yellow,
                                onPressed: () {
                                  debugPrint(
                                      "Start Gis Map ${snapshot.data![index]['gis_url']}");
                                  if (kIsWeb) {
                                    CustomBrowserRedirect.openInBrowser(
                                        snapshot.data![index]['gis_url']);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomWebView(
                                          title:
                                              '${snapshot.data![index]['address']}',
                                          url: snapshot.data![index]['gis_url'],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.open_in_browser,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                tooltip: 'إجراء مكالمة فيديو',
                                hoverColor: Colors.yellow,
                                onPressed: () {
                                  debugPrint(
                                      "Start Video Call ${snapshot.data![index]['id']}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AgoraVideoCall(
                                        title:
                                            '${snapshot.data![index]['address']}',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.video_call,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                tooltip: 'إغلاق الشكوى',
                                hoverColor: Colors.yellow,
                                onPressed: () {
                                  setState(() {
                                    //update is_finished(close broken locations)
                                    DioNetworkRepos().updateLocAddIsFinished(
                                        snapshot.data![index]['address'], 1);
                                    DioNetworkRepos().fetchHandasatUsersItemsBroken(
                                        DataStatic.handasahName,
                                        DataStatic.username,
                                        0); // Manually refresh data after update
                                  });
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                tooltip: 'طلب مهمات مخازن',
                                hoverColor: Colors.yellow,
                                onPressed: () {
                                  //
                                },
                                icon: const Icon(
                                  Icons.local_convenience_store_outlined,
                                  color: Colors.cyan,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          _fetchData(); // Manually refresh data
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

// import 'package:flutter/material.dart';
// import 'package:pick_location/screens/agora_video_call.dart';
// import 'package:pick_location/screens/tracking.dart';

// import '../custom_widget/custom_web_view.dart';
// import '../network/remote/dio_network_repos.dart';

// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});

//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   late Future<List<Map<String, dynamic>>> getUsersBrokenPointsList;

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       //get handasat users items list from db
//       getUsersBrokenPointsList = DioNetworkRepos()
//           .fetchHandasatUsersItemsBroken('handasah', 'user', 0);
//     });
//     getUsersBrokenPointsList
//         .then((value) => debugPrint("PRINTED DATA FROM UI: $value"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'البلاغات المخصصة للمستخدم',
//           style: TextStyle(color: Colors.white),
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
//               return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       margin: const EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           ListTile(
//                             title: Text(
//                               snapshot.data![index]['address'],
//                               style: const TextStyle(
//                                   color: Colors.indigo,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(
//                                 "(${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']})"),
//                           ),
//                           snapshot.data![index]['handasah_name'] == null
//                               ? const SizedBox.shrink()
//                               : ListTile(
//                                   title: Text(
//                                     '${snapshot.data![index]['handasah_name']}, (${snapshot.data![index]['technical_name']})',
//                                     style:
//                                         const TextStyle(color: Colors.indigo),
//                                   ),
//                                 ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   debugPrint(
//                                       "Start Gis Map ${snapshot.data![index]['gis_url']}");
//                                   //open in iframe webview in web app
//                                   // Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(
//                                   //     builder: (context) =>
//                                   //         IframeScreen(
//                                   //             url: snapshot
//                                   //                     .data![index]
//                                   //                 ['gis_url']),
//                                   //   ),
//                                   // );

//                                   //open in browser
//                                   // CustomBrowserRedirect.openInBrowser(
//                                   //   snapshot.data![index]['gis_url'],
//                                   // );
//                                   //open in webview
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CustomWebView(
//                                         title: 'GIS Map webview',
//                                         url: snapshot.data![index]['gis_url'],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.open_in_browser,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   debugPrint(
//                                       "Start Video Call ${snapshot.data![index]['id']}");
//                                   //open video call
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const AgoraVideoCall(),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.video_call,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   debugPrint(
//                                       "Start Traking ${snapshot.data![index]['id']}");
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => const Tracking(),
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.location_on,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                               // IconButton(
//                               //   onPressed: () {
//                               //     setState(() {
//                               //       //update is_finished(close broken locations)
//                               //       DioNetworkRepos().updateLocAddIsFinished(
//                               //           snapshot.data![index]['address'], 1);
//                               //     });
//                               //   },
//                               //   icon: const Icon(
//                               //     Icons.close_rounded,
//                               //     color: Colors.blue,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   });
//             } else if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.indigo,
//         onPressed: () {
//           setState(() {
//             //get handasat users items list from db
//             getUsersBrokenPointsList = DioNetworkRepos()
//                 .fetchHandasatUsersItemsBroken('handasah', 'user', 0);
//           });
//         },
//         mini: true,
//         child: const Icon(
//           Icons.refresh,
//           color: Colors.white,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//     );
//   }
// }


