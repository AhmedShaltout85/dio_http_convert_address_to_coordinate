// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class AddressToCoordinates extends StatefulWidget {
//   const AddressToCoordinates({super.key});

//   @override
//   AddressToCoordinatesState createState() => AddressToCoordinatesState();
// }

// class AddressToCoordinatesState extends State<AddressToCoordinates> {
//   String address =
//       "Grinfel, Bab Sharqi WA Wabour Al Meyah, Bab Sharqi, Alexandria Governorate 5422001";

//   String coordinates = "";
//   String apiKey =
//       'AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk'; // Replace with your actual Google API key

//   // Function to get latitude and longitude from an address using Google Geocoding API
//   Future<void> _getCoordinatesFromAddress(String address) async {
//     final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         // final data = json.decode(response.body);
//         final data = json.decode(response.body);
//         debugPrintStack(label: "Coordinates: $data");
//         debugPrintStack(label: "Coordinates: $response.body");
//         debugPrint(response.toString());

//         if (data['status'] == 'OK') {
//           var location = data['results'][0]['geometry']['location'];
//           setState(() {
//             coordinates =
//                 "Latitude: ${location['lat']}, Longitude: ${location['lng']}";
//           });
//         } else {
//           setState(() {
//             coordinates = "Error: ${data['status']}";
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
//   void initState() {
//     super.initState();
//     _getCoordinatesFromAddress(address); // Convert on startup
//     _getCoordinatesFromAddress(address).then((value) {
//       debugPrint(coordinates);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Address to Coordinates"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Address: $address",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               coordinates,
//               style: const TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pick_location/screens/draggable_scrollable_sheet_screen.dart';

import '../custom_widget/custom_drawer.dart';
import '../custom_widget/custom_end_drawer.dart';
import '../network/remote/dio_network_repos.dart';

class AddressToCoordinates extends StatefulWidget {
  const AddressToCoordinates({super.key});

  @override
  AddressToCoordinatesState createState() => AddressToCoordinatesState();
}

class AddressToCoordinatesState extends State<AddressToCoordinates> {
  final MapController mapController = MapController();
  String address = "";
  String coordinates = "";
  String getAddress = "";
  LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
  double latitude = 0.0, longitude = 0.0;
  var pickMarkers = HashSet<Marker>();
  late Future getLocs; //get addresses from db(HotLine)
  late Future
      getLocsAfterGetCoordinatesAndGis; //get addresses from db(after getting coordinates and gis link)
  late Future getLocsByHandasahNameAndTechinicianName;
  final TextEditingController addressController = TextEditingController();
  late Future getHandasatItemsDropdownMenu;
  List<String> handasatItemsDropdownMenu = [];
  List<String> addHandasahToAddressList = [];

  // Replace with your actual OpenRouteService API key
  String orsApiKey = "5b3ce3597851110001cf6248d0d79559117e4291811ec3f408780f7a";

  //

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
      getLocsAfterGetCoordinatesAndGis =
          DioNetworkRepos().getLocByFlagAndIsFinished();
      getLocsByHandasahNameAndTechinicianName =
          DioNetworkRepos().getLocByHandasahAndTechnician();
    });

    getLocs.then((value) => debugPrint("GET ALL HOTlINE LOCATIONS: $value"));

    getLocsByHandasahNameAndTechinicianName.then((value) =>
        debugPrint("NO HANDASAH AND TECHNICIAN ARE ASSIGNED: $value"));

    //get handasat items dropdown menu from db
    getHandasatItemsDropdownMenu =
        DioNetworkRepos().fetchHandasatItemsDropdownMenu();

    //load list
    getHandasatItemsDropdownMenu.then((value) {
      value.forEach((element) {
        element = element.toString();
        //add to list
        handasatItemsDropdownMenu.add(element);
      });
      //debug print
      debugPrint(
          "handasatItemsDropdownMenu from UI: $handasatItemsDropdownMenu");
      debugPrint(value.toString());
    });
    
  }

  // Function to get latitude and longitude from an address using OpenRouteService
  Future<void> _getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://api.openrouteservice.org/geocode/search?api_key=$orsApiKey&text=${Uri.encodeComponent(address)}&size=1');

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'pick_locations/1.0 (contact@example.com)', // Required
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['features'].isNotEmpty) {
          var location = data['features'][0]['geometry']['coordinates'];
          setState(() {
            coordinates = "Latitude: ${location[1]}, Longitude: ${location[0]}";
            latitude = location[1]; // latitude=y
            longitude = location[0]; // longitude=x

            //add marker
            pickMarkers.add(
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(latitude, longitude),
                child: const Icon(Icons.location_on,
                    color: Colors.red, size: 40.0),
              ),
            );
            //
            debugPrint(address);
            debugPrint(coordinates);
            debugPrint(longitude.toString());
            debugPrint(latitude.toString());

            //update locations after getting coordinates
            getLocs = DioNetworkRepos().getLoc();
            //update locations after getting coordinates and gis link
            getLocsAfterGetCoordinatesAndGis =
                DioNetworkRepos().getLocByFlagAndIsFinished();
            getLocsByHandasahNameAndTechinicianName =
                DioNetworkRepos().getLocByHandasahAndTechnician();
          });

      //get last gis record from GIS server
          int lastRecordNumber = await DioNetworkRepos().getLastRecordNumber();
          debugPrint("lastRecordNumber :>> $lastRecordNumber");
          int newRecordNumber = lastRecordNumber + 1;
          debugPrint("newRecordNumber :>> $newRecordNumber");
          //
          //create new gis point
          String mapLink =
              await DioNetworkRepos().createNewGisPointAndGetMapLink(
            newRecordNumber,
            longitude.toString(),
            latitude.toString(),
          );
          debugPrint("gis_longitude :>> $longitude");
          debugPrint("gis_latitude :>> $latitude");
          debugPrint("GIS MAP LINK :>> $mapLink");

          // check if address already exist(UPDATED-IN-29-01-2025)
          var addressInList =
              await DioNetworkRepos().checkAddressExists(address);
          debugPrint(
              "PRINTED DATA FROM UI:  ${await DioNetworkRepos().checkAddressExists(address)}");
          debugPrint("PRINTED BY USING VAR: $addressInList");
          // debugPrint("PRINTED BY USING STRING: $addressInListString");
          //
          //
          if (addressInList == true) {
            //  call the function to update locations in database
            debugPrint("address already exist >>>>>> $addressInList");

            //  call the function to update locations in database
            //update Locations list after getting coordinates and gis link
            await DioNetworkRepos().updateLocations(
              address,
              longitude,
              latitude,
              mapLink,
            );
            //
            debugPrint(
                "updated Locations list after getting coordinates and gis link");
          } else {
            //  call the function to post locations in database
            debugPrint("address not exist >>>>>>>>> $addressInList");

            //  call the function to post locations in database
            await DioNetworkRepos().createNewLocation(
              address,
              longitude,
              latitude,
              mapLink,
            );
            //
            debugPrint(
                "POSTED new Location In Locations list after getting coordinates and gis link");
          }

          //update Locations list after getting coordinates

          setState(() {
            getLocs = DioNetworkRepos().getLoc();
            //update locations after getting coordinates and gis link
            getLocsAfterGetCoordinatesAndGis =
                DioNetworkRepos().getLocByFlagAndIsFinished();
            getLocsByHandasahNameAndTechinicianName =
                DioNetworkRepos().getLocByHandasahAndTechnician();
          });


        } else {
          setState(() {
            coordinates = "Error: No results found";
          });
        }
      } else {
        setState(() {
          coordinates = "Error: Failed to fetch data";
        });
      }
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
          "Address to Coordinates (ORS)",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white, size: 17),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
                initialCenter: alexandriaCoordinates,
                initialZoom: 10.4746,
                onMapReady: () => setState(() {
                      _getCoordinatesFromAddress(address);
                    })),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: pickMarkers.toList(),
              ),
              // PolylineLayer(
              //   polylines: [
              //     Polyline(
              //       points: [
              //         const LatLng(31.205753, 29.924526),
              //         const LatLng(31.205753, 29.924526),
              //       ],
              //       strokeWidth: 2.0,
              //       color: Colors.red,
              //     ),
              //   ],
              // ),
            ],
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
                          content: const Text("فضلا أدخل العنوان"),
                          backgroundColor: Colors.indigo.shade300,
                        ),
                      );
                    }
                    setState(() {
                      pickMarkers.clear();
                      address = addressController.text;
                      _getCoordinatesFromAddress(address);
                      addressController.clear();
                      //update locations after getting coordinates
                      getLocs = DioNetworkRepos().getLoc();
                      //update locations after getting coordinates and gis link
                      getLocsAfterGetCoordinatesAndGis =
                          DioNetworkRepos().getLocByFlagAndIsFinished();
                      getLocsByHandasahNameAndTechinicianName =
                          DioNetworkRepos().getLocByHandasahAndTechnician();
                    });
                  },
                  icon: const Icon(
                    Icons.search_outlined,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
          //CustomDraggableSheet
          DraggableScrollableSheetScreen(
            getLocs: getLocsAfterGetCoordinatesAndGis,
          ), //call draggable sheet
          //CustomDraggableSheet
        ],
      ),
      drawer: CustomDrawer(
        getLocs: getLocs,
      ),
      endDrawer: CustomEndDrawer(
        title: 'Addresses List With coordinates',
        getLocs: getLocsByHandasahNameAndTechinicianName,
        stringListItems: handasatItemsDropdownMenu,
        onPressed: () {
          //
          setState(() {
            getLocsByHandasahNameAndTechinicianName =
                DioNetworkRepos().getLocByHandasahAndTechnician();
          });
        },
        hintText: 'فضلا أختار الهندسة',
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          // pickMarkers.clear();
          setState(() {
            getLocs = DioNetworkRepos().getLoc();
            //update locations after getting coordinates
            getLocsAfterGetCoordinatesAndGis =
                DioNetworkRepos().getLocByFlagAndIsFinished();
            getLocsByHandasahNameAndTechinicianName =
                DioNetworkRepos().getLocByHandasahAndTechnician();
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
