// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:pick_location/screens/draggable_scrollable_sheet_screen.dart';

// import '../custom_widget/custom_drawer.dart';
// import '../custom_widget/custom_end_drawer.dart';
// import '../network/remote/dio_network_repos.dart';

// class AddressToCoordinates extends StatefulWidget {
//   const AddressToCoordinates({super.key});

//   @override
//   AddressToCoordinatesState createState() => AddressToCoordinatesState();
// }

// class AddressToCoordinatesState extends State<AddressToCoordinates> {
//   final Completer<GoogleMapController> _controller = Completer();

//   String address = "";
//   String coordinates = "";
//   String getAddress = "";
//   LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
//   double latitude = 0.0, longitude = 0.0;
//   var pickMarkers = HashSet<Marker>();
//   late Future getLocs; //get addresses from db(HotLine)
//   late Future
//       getLocsAfterGetCoordinatesAndGis; //get addresses from db(after getting coordinates and gis link)
//   late Future getLocsByHandasahNameAndTechinicianName;
//   final TextEditingController addressController = TextEditingController();
//   late Future getHandasatItemsDropdownMenu;
//   List<String> handasatItemsDropdownMenu = [];
//   List<String> addHandasahToAddressList = [];

//   // Replace with your actual Google Maps API key
//   String googleMapsApiKey = "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";

//   @override
//   void dispose() {
//     // Dispose the controller when the widget is disposed
//     addressController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       getLocs = DioNetworkRepos().getLoc();
//       getLocsAfterGetCoordinatesAndGis =
//           DioNetworkRepos().getLocByFlagAndIsFinished();
//       getLocsByHandasahNameAndTechinicianName =
//           DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
//     });

//     getLocs.then((value) => debugPrint("GET ALL HOTlINE LOCATIONS: $value"));

//     getLocsByHandasahNameAndTechinicianName.then((value) =>
//         debugPrint("NO HANDASAH AND TECHNICIAN ARE ASSIGNED: $value"));

//     //get handasat items dropdown menu from db
//     getHandasatItemsDropdownMenu =
//         DioNetworkRepos().fetchHandasatItemsDropdownMenu();

//     //load list
//     getHandasatItemsDropdownMenu.then((value) {
//       value.forEach((element) {
//         element = element.toString();
//         //add to list
//         handasatItemsDropdownMenu.add(element);
//       });
//       //debug print
//       debugPrint(
//           "handasatItemsDropdownMenu from UI: $handasatItemsDropdownMenu");
//       debugPrint(value.toString());
//     });
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
//             getLocs = DioNetworkRepos().getLoc();
//             //update locations after getting coordinates and gis link
//             getLocsAfterGetCoordinatesAndGis =
//                 DioNetworkRepos().getLocByFlagAndIsFinished();
//             getLocsByHandasahNameAndTechinicianName =
//                 DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
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
//             getLocs = DioNetworkRepos().getLoc();
//             //update locations after getting coordinates and gis link
//             getLocsAfterGetCoordinatesAndGis =
//                 DioNetworkRepos().getLocByFlagAndIsFinished();
//             getLocsByHandasahNameAndTechinicianName =
//                 DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
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
//           "تحديد موقع عنوان على الخريطة (Google Maps)",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.indigo,
//         iconTheme: const IconThemeData(color: Colors.white, size: 17),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: alexandriaCoordinates,
//               zoom: 10.4746,
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//             markers: pickMarkers,
//             zoomControlsEnabled: true,
//           ),

//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: const InputDecoration(
//                       constraints: BoxConstraints(
//                         maxHeight: 70,
//                         minWidth: 200,
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                       ),
//                       hintText: "فضلا أدخل العنوان",
//                       hintStyle: TextStyle(
//                         color: Colors.indigo,
//                         fontSize: 11,
//                       ),
//                     ),
//                     controller:
//                         addressController, // set the controller to get address input
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Colors.indigo,
//                     ),
//                     cursorColor: Colors.amber,
//                     keyboardType: TextInputType.text,
//                     maxLength: 250,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 17.0),
//                   child: IconButton(
//                     alignment: Alignment.center,
//                     onPressed: () async {
//                       if (addressController.text.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: const Text("فضلا أدخل العنوان"),
//                             backgroundColor: Colors.indigo.shade300,
//                           ),
//                         );
//                       }
//                       setState(() {
//                         pickMarkers.clear();
//                         address = addressController.text;
//                         _getCoordinatesFromAddress(address);
//                         addressController.clear();
//                         //update locations after getting coordinates
//                         getLocs = DioNetworkRepos().getLoc();
//                         //update locations after getting coordinates and gis link
//                         getLocsAfterGetCoordinatesAndGis =
//                             DioNetworkRepos().getLocByFlagAndIsFinished();
//                         getLocsByHandasahNameAndTechinicianName =
//                             DioNetworkRepos()
//                                 .getLocByHandasahAndTechnician("free", "free");
//                       });
//                     },
//                     icon: const CircleAvatar(
//                       backgroundColor: Colors.indigo,
//                       radius: 20,
//                       child: Icon(
//                         Icons.search_outlined,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           //CustomDraggableSheet
//           DraggableScrollableSheetScreen(
//             getLocs: getLocsAfterGetCoordinatesAndGis,
//           ), //call draggable sheet
//           //CustomDraggableSheet
//         ],
//       ),
//       drawer: CustomDrawer(
//         title: 'الاعطال الواردة من الخط الساخن',
//         getLocs: getLocs,
//       ),
//       endDrawer: CustomEndDrawer(
//         title: 'تخصيص الهندسة',
//         getLocs: getLocsByHandasahNameAndTechinicianName,
//         stringListItems: handasatItemsDropdownMenu,
//         onPressed: () {
//           //
//           setState(() {
//             getLocsByHandasahNameAndTechinicianName =
//                 DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
//           });
//         },
//         hintText: 'فضلا أختار الهندسة',
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.indigo,
//         onPressed: () {
//           // pickMarkers.clear();
//           setState(() {
//             getLocs = DioNetworkRepos().getLoc();
//             //update locations after getting coordinates
//             getLocsAfterGetCoordinatesAndGis =
//                 DioNetworkRepos().getLocByFlagAndIsFinished();
//             getLocsByHandasahNameAndTechinicianName =
//                 DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
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

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pick_location/screens/address_details.dart';
import 'package:pick_location/screens/agora_video_call.dart';
// import 'package:pick_location/screens/draggable_scrollable_sheet_screen.dart';
import 'package:pick_location/screens/tracking.dart';

import '../custom_widget/custom_browser_redirect.dart';
import '../custom_widget/custom_drawer.dart';
import '../custom_widget/custom_end_drawer.dart';
import '../network/remote/dio_network_repos.dart';

class AddressToCoordinates extends StatefulWidget {
  const AddressToCoordinates({super.key});

  @override
  AddressToCoordinatesState createState() => AddressToCoordinatesState();
}

class AddressToCoordinatesState extends State<AddressToCoordinates> {
  final Completer<GoogleMapController> _controller = Completer();

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

  // Replace with your actual Google Maps API key
  String googleMapsApiKey = "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";

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
          DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
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

  // Function to get latitude and longitude from an address using Google Maps Geocoding API
  Future<void> _getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'].isNotEmpty) {
          var location = data['results'][0]['geometry']['location'];
          setState(() {
            coordinates =
                "Latitude: ${location['lat']}, Longitude: ${location['lng']}";
            latitude = location['lat']; // latitude
            longitude = location['lng']; // longitude

            //add marker
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
                DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
          });

          //get last gis record from GIS server
          int lastRecordNumber = await DioNetworkRepos()
              .getLastRecordNumberWeb(); //get last gis record from GIS serverWEB-NO-BODY
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
                DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
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
          "تحديد موقع عنوان على الخريطة (غرفة الطوارئ)",
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
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: 220,
              height: MediaQuery.of(context).size.height,
              // color: Colors.black45,
              child: CustomEndDrawer(
                title: 'تخصيص شكاوى الهندسة',
                getLocs: getLocsByHandasahNameAndTechinicianName,
                stringListItems: handasatItemsDropdownMenu,
                onPressed: () {
                  //
                  setState(() {
                    getLocsByHandasahNameAndTechinicianName = DioNetworkRepos()
                        .getLocByHandasahAndTechnician("free", "free");
                  });
                },
                hintText: 'فضلا أختار الهندسة',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Stack(
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
                              hintText: "فضلا أدخل العنوان",
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 17.0),
                          child: IconButton(
                            alignment: Alignment.center,
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
                                    DioNetworkRepos()
                                        .getLocByFlagAndIsFinished();
                                getLocsByHandasahNameAndTechinicianName =
                                    DioNetworkRepos()
                                        .getLocByHandasahAndTechnician(
                                            "free", "free");
                              });
                            },
                            icon: const CircleAvatar(
                              backgroundColor: Colors.indigo,
                              radius: 20,
                              child: Icon(
                                Icons.search_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //CustomDraggableSheet
                  // DraggableScrollableSheetScreen(
                  //   getLocs: getLocsAfterGetCoordinatesAndGis,
                  // ), //call draggable sheet
                  //CustomDraggableSheet
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: 220,
              height: MediaQuery.of(context).size.height,
              color: Colors.black45,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      color: Colors.indigo,
                      child: const Center(
                        child: Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          'جميع الشكاوى غير المغلقة',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: getLocsAfterGetCoordinatesAndGis,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            snapshot.data![index]['address'],
                                            style: const TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  // width: 15,
                                                  child: Text(
                                                    "${snapshot.data![index]['handasah_name']}",
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  //  snapshot.data![index]
                                                  //                 ['handasah_name'] !=
                                                  //             "free" ||
                                                  //         snapshot.data![index]
                                                  //                 ['technical_name'] !=
                                                  //             "free"
                                                  //     ? Text(
                                                  //         '${snapshot.data![index]['handasah_name']}, (${snapshot.data![index]['technical_name']})')
                                                  //     : const SizedBox.shrink(),
                                                ),
                                                Container(
                                                  color: Colors.white,
                                                  // width: 15,
                                                  child: Text(
                                                    "${snapshot.data![index]['technical_name']}",
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.green),
                                                  ),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'تم قبول الشكوى',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              tooltip:
                                                  'التوجهه للخريطة GIS Map',
                                              hoverColor: Colors.yellow,
                                              onPressed: () {
                                                debugPrint(
                                                    "Start Gis Map ${snapshot.data![index]['gis_url']}");
                                                //open in iframe webview in web app
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         IframeScreen(
                                                //             url: snapshot
                                                //                     .data![index]
                                                //                 ['gis_url']),
                                                //   ),
                                                // );

                                                //open in browser
                                                CustomBrowserRedirect
                                                    .openInBrowser(
                                                  snapshot.data![index]
                                                      ['gis_url'],
                                                );
                                                //open in webview
                                                //   Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           CustomWebView(
                                                //         title: 'GIS Map webview',
                                                //         url: snapshot.data![index]
                                                //             ['gis_url'],
                                                //       ),
                                                //     ),
                                                //   );
                                              },
                                              icon: const Icon(
                                                Icons.open_in_browser,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'أجراء مكالمة فيديو',
                                              hoverColor: Colors.yellow,
                                              onPressed: () {
                                                debugPrint(
                                                    "Start Video Call ${snapshot.data![index]['id']}");
                                                //open video call
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AgoraVideoCall(
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
                                              tooltip: 'بدء تتبع فنى الهندسة',
                                              hoverColor: Colors.yellow,
                                              onPressed: () {
                                                debugPrint(
                                                    "Start Traking ${snapshot.data![index]['id']}");
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Tracking(),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'إبلاغ كسورات معامل',
                                              hoverColor: Colors.yellow,
                                              onPressed: () {
                                                
                                              },
                                              icon: const Icon(
                                                Icons.broken_image_outlined,
                                                color: Colors.purple,
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'مهمات مخازن مطلوبة',
                                              hoverColor: Colors.yellow,
                                              onPressed: () {
                                               
                                              },
                                              icon: const Icon(
                                                Icons.store_sharp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            // IconButton(
                                            //   onPressed: () {
                                            //     setState(() {
                                            //       //update is_finished(close broken locations)
                                            //       DioNetworkRepos()
                                            //           .updateLocAddIsFinished(
                                            //               snapshot.data![index]
                                            //                   ['address'],
                                            //               1);
                                            //     });
                                            //     // debugPrint(
                                            //     //     "Start Traking ${snapshot.data![index]['id']}");
                                            //     // Navigator.push(
                                            //     //   context,
                                            //     //   MaterialPageRoute(
                                            //     //     builder: (context) =>
                                            //     //         const Tracking(),
                                            //     //   ),
                                            //     // );
                                            //   },
                                            //   icon: const Icon(
                                            //     Icons.close_rounded,
                                            //     color: Colors.blue,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    debugPrint("${snapshot.data[index]['id']}");
                                    // open address details
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddressDetails(),
                                      ),
                                    );
                                  },
                                );
                              },
                              // physics: const NeverScrollableScrollPhysics(),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(
        title: 'الاعطال الواردة من الخط الساخن',
        getLocs: getLocs,
      ),
      // endDrawer: CustomEndDrawer(
      //   title: 'تخصيص الهندسة',
      //   getLocs: getLocsByHandasahNameAndTechinicianName,
      //   stringListItems: handasatItemsDropdownMenu,
      //   onPressed: () {
      //     //
      //     setState(() {
      //       getLocsByHandasahNameAndTechinicianName =
      //           DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
      //     });
      //   },
      //   hintText: 'فضلا أختار الهندسة',
      // ),
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
                DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
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
