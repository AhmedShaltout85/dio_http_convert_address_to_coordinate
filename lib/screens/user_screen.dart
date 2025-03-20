// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_field

import 'dart:async'; // Import Timer
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:pick_location/custom_widget/custom_browser_redirect.dart';
import 'package:pick_location/screens/agora_video_call.dart';
import 'package:pick_location/screens/integration_with_stores_get_all_qty.dart';
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
  String storeName = "";

  // StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initial fetch
    _getCurrentLocation(); // Get current location
    _startPeriodicFetch(); // Start periodic fetching
    // _startFetchingLocation(); // Start fetching location every 1 minutes
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel periodic fetch and location update timer
    // locationSubscription?.cancel(); // Cancel location listener subscription
    super.dispose();
  }

  // Function to fetch data
  void _fetchData() {
    setState(() {
      getUsersBrokenPointsList = DioNetworkRepos()
          .fetchHandasatUsersItemsBroken(
              DataStatic.handasahName, DataStatic.username, 0);
    });
    getUsersBrokenPointsList.then((value) {
      debugPrint("PRINTED DATA FROM UI: $value");
      if (value.isEmpty) {
        debugPrint("Data is empty, will retry...");
      }
    });
  }

// Function to get current location(with permission request)
  Future<void> _getCurrentLocation() async {
    var location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
      // location.enableBackgroundMode(enable: true);
    }

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }

    // locationSubscription = //not tested
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  //Function to start fetching updated location
  void _startFetchingLocation() {
    const updateInterval = Duration(minutes: 1);
    // if (currentLocation != null) {
    _timer = Timer.periodic(updateInterval, (Timer timer) {
      DioNetworkRepos().updateLocationToBackend(
          address, currentLocation!.latitude!, currentLocation!.longitude!);
    });
    // }
  }
  // //Function to start fetching updated location
  // void _startFetchingLocation() {
  //   // _getCurrentLocation();
  //   DioNetworkRepos().updateLocationToBackend(
  //       address, currentLocation!.latitude!, currentLocation!.longitude!);
  // }

  // Function to start periodic fetching
  void _startPeriodicFetch() {
    const Duration fetchInterval =
        Duration(minutes: 30); // Fetch every 10 seconds
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
          style: const TextStyle(color: Colors.white, fontSize: 15),
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
                              textAlign: TextAlign.center,
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
                                                onPressed: () async {
                                                  //update isApproved
                                                  await DioNetworkRepos()
                                                      .updateLocAddIsApproved(
                                                          snapshot.data![index]
                                                              ['address'],
                                                          1);
                                                  setState(() {
                                                    isApproved = 1;
                                                  });
                                                  //fetch data
                                                  _fetchData();

                                                  // check if address already exist(UPDATED-IN-29-01-2025)
                                                  var addressInList =
                                                      await DioNetworkRepos()
                                                          .checkAddressExistsInTracking(
                                                              address);
                                                  debugPrint(
                                                      "PRINTED DATA FROM UI:  ${await DioNetworkRepos().checkAddressExistsInTracking(address)}");
                                                  debugPrint(
                                                      "PRINTED BY USING VAR: $addressInList");

                                                  if (addressInList == true) {
                                                    //  call the function to update locations in database
                                                    debugPrint(
                                                        "address already exist >>>>>> $addressInList");

                                                    //  call the function to update locations in database
                                                    await DioNetworkRepos()
                                                        .updateTrackingLocations(
                                                            address,
                                                            double
                                                                .parse(snapshot
                                                                            .data![
                                                                        index]
                                                                    [
                                                                    'longitude']),
                                                            double
                                                                .parse(snapshot
                                                                            .data![
                                                                        index]
                                                                    [
                                                                    'latitude']),
                                                            currentLocation!
                                                                .latitude!,
                                                            currentLocation!
                                                                .longitude!,
                                                            currentLocation
                                                                ?.latitude,
                                                            currentLocation
                                                                ?.longitude,
                                                            snapshot.data![
                                                                    index][
                                                                'technical_name']);
                                                    // //updated Location
                                                    _startFetchingLocation();
                                                  } else {
                                                    //post current user Location

                                                    await DioNetworkRepos()
                                                        .sendLocationToBackend(
                                                            snapshot.data![index]
                                                                ['address'],
                                                            snapshot.data![
                                                                    index][
                                                                'technical_name'],
                                                            double.parse(snapshot
                                                                        .data![
                                                                    index]
                                                                ['latitude']),
                                                            double.parse(snapshot
                                                                        .data![
                                                                    index]
                                                                ['longitude']),
                                                            currentLocation
                                                                ?.latitude,
                                                            currentLocation
                                                                ?.longitude);
                                                    debugPrint(
                                                        'address: ${snapshot.data![index]['address']}, latitude: ${snapshot.data![index]['latitude']},longitude: ${snapshot.data![index]['longitude']},currentLocation?.latitude: ${currentLocation?.latitude},currentLocation?.longitude: ${currentLocation?.longitude}, technical_name: ${snapshot.data![index]['technical_name']}');

                                                    debugPrint(
                                                        'Updated status to approved and refreshed UI.');
                                                    // //updated Location
                                                    _startFetchingLocation();
                                                  }

                                                  //refresh UI
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
                                                  // _startFetchingLocation();
                                                },
                                                child: const Text(
                                                  'تم قبول الشكوى',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                          ListTile(
                            title: Text(
                              'الاحداثئات :  ${snapshot.data![index]['latitude']} , ${snapshot.data![index]['longitude']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'إسم المبلغ :  ${snapshot.data![index]['caller_name']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              ' رقم هاتف المبلغ:  ${snapshot.data![index]['caller_phone']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'نوع الكسر :  ${snapshot.data![index]['broker_type']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
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
                              IconButton(
                                tooltip: 'جرد مخزن',
                                hoverColor: Colors.yellow,
                                onPressed: () async {
                                  //
                                  //get store name by handasah
                                  debugPrint(
                                      "Store Name before get: $storeName");
                                  debugPrint(
                                      "Handasah Name before get: ${snapshot.data![index]['handasah_name']}");
                                  await DioNetworkRepos()
                                      .getStoreNameByHandasahName(snapshot
                                          .data![index]['handasah_name'])
                                      .then((value) {
                                    // setState(() {
                                    debugPrint(value['storeName']);
                                    storeName = value['storeName'];
                                    // });
                                  });
                                  debugPrint(
                                      "Store Name after get: $storeName");
                                  //excute tempStoredProcedure
                                  DioNetworkRepos()
                                      .excuteTempStoreQty(storeName);

                                  //navigate to IntegrationWithStoresGetAllQty
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IntegrationWithStoresGetAllQty(
                                        storeName: storeName,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.store_outlined,
                                  color: Colors.indigo,
                                ),
                              ),
                              IconButton(
                                tooltip: 'إغلاق الشكوى',
                                hoverColor: Colors.yellow,
                                onPressed: () {
                                  setState(() {
                                    // //stop live Location
                                    // _stopFetchingLocation(); //not tested

                                    //update is_finished(close broken locations)
                                    DioNetworkRepos().updateLocAddIsFinished(
                                        snapshot.data![index]['address'], 1);
                                    //
                                    DioNetworkRepos().fetchHandasatUsersItemsBroken(
                                        DataStatic.handasahName,
                                        DataStatic.username,
                                        0); // Manually refresh data after update
                                    snapshot.data!.removeAt(0);
                                  });
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
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
        backgroundColor: Colors.cyan,
        onPressed: () {
          _fetchData(); // Manually refresh data
        },
        mini: true,
        tooltip: 'تحديث',
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
