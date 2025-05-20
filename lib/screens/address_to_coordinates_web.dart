// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
// import 'package:pick_location/screens/agora_video_call.dart';
// import 'package:pick_location/screens/caller_mobile_screen.dart';
// import 'package:pick_location/screens/caller_screen.dart';
// import 'package:pick_location/screens/dashboard_screen.dart';
// import 'package:pick_location/screens/integration_with_stores_get_all_qty.dart';
// import 'package:pick_location/screens/report_screen.dart';
// import 'package:pick_location/screens/tracking.dart';

import '../custom_widget/custom_reusable_alert_dailog.dart';
import '../custom_widget/custom_bottom_sheet.dart';
import '../custom_widget/custom_browser_redirect.dart';
import '../custom_widget/custom_drawer.dart';
import '../custom_widget/custom_end_drawer.dart';
import '../custom_widget/custom_text_button_drop_down_menu.dart';
import '../custom_widget/cutom_texts_alert_dailog.dart';
import '../network/remote/dio_network_repos.dart';

class AddressToCoordinates extends StatefulWidget {
  const AddressToCoordinates({super.key});

  @override
  AddressToCoordinatesState createState() => AddressToCoordinatesState();
}

class AddressToCoordinatesState extends State<AddressToCoordinates> {
  String storeName = "";
  final Completer<GoogleMapController> _controller = Completer();

  String address = "";
  String coordinates = "";
  String getAddress = "";
  LatLng alexandriaCoordinates = const LatLng(31.205753, 29.924526);
  double latitude = 0.0, longitude = 0.0;
  var pickMarkers = HashSet<Marker>();
  late Future
      getLocsAfterGetCoordinatesAndGis; //get addresses from db(after getting coordinates and gis link)
  late Future getLocsByHandasahNameAndTechinicianName;
  final TextEditingController addressController = TextEditingController();
  late Future getHandasatItemsDropdownMenu;
  List<String> handasatItemsDropdownMenu = [];
  List<String> addHandasahToAddressList = [];
  late Future<List<Map<String, dynamic>>> getAllHotLineAddresses;

  // Replace with your actual Google Maps API key
  String googleMapsApiKey = "AIzaSyDRaJJnyvmDSU8OgI8M20C5nmwHNc_AMvk";
  double fontSize = 12.0;
  Timer? _timer; // Timer for periodic fetching
  // BitmapDescriptor? pinLocationIcon;

  @override
  void dispose() {
    _timer?.cancel(); // Cancel periodic fetch and location update timer
    // Dispose the controller when the widget is disposed
    addressController.dispose();
    super.dispose();
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

  //update in periodic time
  void _startPeriodicFetch() {
    const Duration fetchInterval =
        Duration(seconds: 10); // Fetch every 10 seconds
    _timer = Timer.periodic(fetchInterval, (Timer timer) {
      setState(() {
        // getAllHotLineAddresses = DioNetworkRepos().getLoc();
        getLocsAfterGetCoordinatesAndGis =
            DioNetworkRepos().getLocByFlagAndIsFinished();
        getLocsByHandasahNameAndTechinicianName =
            DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // BitmapDescriptor.asset(
    //         const ImageConfiguration(
    //           size: Size(40, 40),
    //         ),
    //         'assets/green_marker.png')
    //     .then((onValue) {
    //   pinLocationIcon = onValue;
    // });
    _initializeApp();

    setState(() {
      // getLocs = DioNetworkRepos().getLoc();
      getLocsAfterGetCoordinatesAndGis =
          DioNetworkRepos().getLocByFlagAndIsFinished();
      getLocsByHandasahNameAndTechinicianName =
          DioNetworkRepos().getLocByHandasahAndTechnician("free", "free");
    });

    // getLocs.then((value) => debugPrint("GET ALL HOTlINE LOCATIONS: $value"));

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
    //start periodic fetch
    _startPeriodicFetch();
  }

  // Function to get latitude and longitude from an address using Google Maps Geocoding API
  Future<void> _getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleMapsApiKey');

    final GoogleMapController controller = await _controller.future;

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
                icon:
                    // pinLocationIcon!,
                    BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
              ),
            );
            // Move camera to the new location
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 15.0, // You can adjust the zoom level as needed
                ),
              ),
            );
            //
            debugPrint(address);
            debugPrint(coordinates);
            debugPrint(longitude.toString());
            debugPrint(latitude.toString());

            //update locations after getting coordinates
            // getLocs = DioNetworkRepos().getLoc();
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
            // getLocs = DioNetworkRepos().getLoc();
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

  //show bottom sheet Redirect to Handasat
  void showCustomBottomSheet(
      BuildContext context, String title, String message, String address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false, // Ensures it takes full width
      builder: (context) {
        return CustomBottomSheet(
          title: title,
          message: message,
          hintText: "اختر الهندسة",
          dropdownItems: handasatItemsDropdownMenu,
          onItemSelected: (value) {
            debugPrint("Selected: $value");
            setState(() {
              DioNetworkRepos().updateLocAddHandasah(address, value);
            });
          },
          onPressed: () async {
            Navigator.of(context).pop();
            await DioNetworkRepos().updateLocAddTechnician(address, "free");
            await DioNetworkRepos().updateLocAddIsApproved(address, 0);
          },
        );
      },
    );
  }

//handle dropdown click
  void handleOptionClick(String value) {
    // You can handle button actions here
    debugPrint("Clicked: $value");
    if (value == 'عرض التقارير') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ReportScreen(),
      // ),
      // );
      context.push('/report');
    } else if (value == 'الربط مع الاسكادا') {
      CustomBrowserRedirect.openInBrowser(
        'http://41.33.226.211:8070/roundpoint',
        // 'http://192.168.30.12:80/roundpoint',
      );
    } else if (value == 'عرض المناطق المزدحمة بالبلاغات') {
      CustomBrowserRedirect.openInBrowser(
        'http://196.219.231.3:8000/webmap/breaks-hot-spots',
      );
    } else if (value == 'عرض تقرير الاسكادا Dashboard') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const StationsDashboard(),
      //   ),
      // );
      context.push('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          " غرفة الطوارئ",
          style: TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
        elevation: 7,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.indigo,
          size: 17,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            tooltip: "تحديث شكاوى الخط الساخن",
            hoverColor: Colors.yellow,
            onPressed: () {
              _initializeApp();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.indigo,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            tooltip: "إضافة مستخدمين الطوارئ",
            hoverColor: Colors.yellow,
            icon: const Icon(
              Icons.person_add_alt,
              color: Colors.indigo,
            ),
            onPressed: () {
              //
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomReusableAlertDialog(
                        title: 'اضافة مستخدمين الطوارئ',
                        fieldLabels: const [
                          'اسم المستخدم',
                          'كلمة المرور',
                          'مطابقة كلمة المرور',
                        ],
                        onSubmit: (values) {
                          DioNetworkRepos().createNewUser(
                              values[0], values[1], 1, 'غرفة الطوارئ');
                        });
                  });
              debugPrint(
                  "User Input: updated Caller Name, Phone, And Borken Number");
            },
          ),
          TextButtonDropdown(
            label: 'التقارير',
            options: const [
              'عرض التقارير',
              'الربط مع الاسكادا',
              'عرض المناطق المزدحمة بالبلاغات',
              'عرض تقرير الاسكادا Dashboard',
            ],
            onSelected: handleOptionClick,
          ),
        ],
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
                    //update locations after getting coordinates
                    getLocsAfterGetCoordinatesAndGis =
                        DioNetworkRepos().getLocByFlagAndIsFinished();
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
                    onCameraMoveStarted: () async {
                      //
                      final GoogleMapController controller =
                          await _controller.future;
                      CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      );
                      controller.animateCamera(
                          CameraUpdate.newCameraPosition(cameraPosition));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              constraints: const BoxConstraints(
                                maxHeight: 70,
                                minWidth: 200,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              hintText: "فضلا أدخل العنوان",
                              hintStyle: TextStyle(
                                color: Colors.indigo[200],
                                fontSize: 11,
                              ),
                              labelText: "61 طريق الحرية الاسكندرية",
                            ),
                            controller:
                                addressController, // set the controller to get address input
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.indigo,
                            ),
                            cursorColor: Colors.indigo,
                            keyboardType: TextInputType.text,
                            maxLength: 250, textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 17.0),
                          child: IconButton(
                            alignment: Alignment.center,
                            onPressed: () async {
                              if (addressController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      " فضلا ادخل العنوان, ثم اضغط على البحث",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                pickMarkers.clear();
                                address = addressController.text;
                                _getCoordinatesFromAddress(address);
                                addressController.clear();
                                //update locations after getting coordinates
                                // getLocs = DioNetworkRepos().getLoc();
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
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    //display bottom sheet
                                    showCustomBottomSheet(
                                      context,
                                      "إعادة التوجيه للهندسة",
                                      snapshot.data![index]['address'],
                                      snapshot.data![index]['address'],
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 3.0),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  tooltip:
                                                      "إضافة بيانات الشكوى",
                                                  onPressed: () {
                                                    //
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CustomReusableAlertDialog(
                                                        title:
                                                            "تحديث بيانات الشكوى",
                                                        fieldLabels: const [
                                                          "إسم المبلغ",
                                                          "نوع الكسر",
                                                          "رقم الموبيل"
                                                        ],
                                                        onSubmit: (values) {
                                                          debugPrint(
                                                              "User Input: $values"); // values[0]=Name, values[1]=Email, etc.
                                                          DioNetworkRepos()
                                                              .updateLocationBrokenByAddress(
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'address'],
                                                                  values[0],
                                                                  values[1],
                                                                  values[2]);
                                                          debugPrint(
                                                              "User Input: updated Caller Name, Phone, And Borken Number");
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.add_circle_outlined,
                                                    color: Colors.indigo,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    textAlign: TextAlign.right,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    snapshot.data![index]
                                                        ['address'],
                                                    style: const TextStyle(
                                                      color: Colors.indigo,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 3.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    snapshot.data![index][
                                                                'handasah_name'] ==
                                                            'free'
                                                        ? Expanded(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .orange),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "قيد تخصيص هندسة",
                                                                style:
                                                                    TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          1.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .green),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "${snapshot.data![index]['handasah_name']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    snapshot.data![index][
                                                                'technical_name'] ==
                                                            "free"
                                                        ? Expanded(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .orange),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "قيد تخصيص فنى",
                                                                style:
                                                                    TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .green),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "${snapshot.data![index]['technical_name']}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: snapshot.data![
                                                                      index][
                                                                  'is_approved'] ==
                                                              1
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .green),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                'تم قبول الشكوى',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .orange),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                'قيد قبول الشكوى',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                    Expanded(
                                                      child: snapshot.data![
                                                                      index][
                                                                  'broker_type'] !=
                                                              "لم يدرج نوع الكسر"
                                                          ? Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .green),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                '${snapshot.data![index]['broker_type']}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .orange,
                                                                      width:
                                                                          1.0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  color: Colors
                                                                      .orange),
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                'لم يدرج نوع الكسر',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      fontSize,
                                                                  color: Colors
                                                                      .white,
                                                                  // fontWeight:
                                                                  //     FontWeight
                                                                  //         .bold,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: IconButton(
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
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'أجراء مكالمة فيديو',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {
                                                  debugPrint(
                                                      "Start Video Call ${snapshot.data![index]['id']}");
                                                  if (snapshot.data![index]
                                                          ['is_approved'] ==
                                                      0) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                        'لايمكن إجراء مكالمة فيديو قبل قبول الفنى الشكوى',
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    );
                                                  } else {
                                                    //update video call status(23-03-2025)
                                                    DioNetworkRepos()
                                                        .updateLocationBrokenByAddressUpdateVideoCall(
                                                            snapshot.data![
                                                                    index]
                                                                ['address'],
                                                            1);
                                                    //open video call
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         AgoraVideoCall(
                                                    //       title:
                                                    //           '${snapshot.data![index]['address']}',
                                                    //     ),
                                                    //   ),
                                                    // );

                                                    //open Video Call from online server
                                                    context.push(
                                                        '/mobile-caller/${snapshot.data![index]['address']}');

                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         CallerMobileScreen(
                                                    //             addressTitle:
                                                    //                 '${snapshot.data![index]['address']}'),
                                                    //   ),
                                                    // );
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.video_call,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'بدء تتبع فنى الهندسة',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {
                                                  debugPrint(
                                                      "Start Traking ${snapshot.data![index]['id']}");
                                                  if (snapshot.data![index]
                                                          ['is_approved'] ==
                                                      0) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                        'الشكوى قيد القبول وجارى التفعيل',
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    );
                                                  } else {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         Tracking(
                                                    //       address:
                                                    //           '${snapshot.data![index]['address']}',
                                                    //       latitude:
                                                    //           "${snapshot.data![index]['latitude']}",
                                                    //       longitude:
                                                    //           '${snapshot.data![index]['longitude']}',
                                                    //       technicianName:
                                                    //           '${snapshot.data![index]['technical_name']}',
                                                    //     ),
                                                    //   ),
                                                    // );
                                                    context.push(
                                                        '/tracking/${snapshot.data![index]['address']}/${snapshot.data![index]['latitude']}/${snapshot.data![index]['longitude']}/${snapshot.data![index]['technical_name']}');
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'جرد مخزن',
                                                hoverColor: Colors.yellow,
                                                onPressed: () async {
                                                  //if store name is empty
                                                  if (snapshot.data![index]
                                                          ['handasah_name'] ==
                                                      'free') {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                        'عفوا, لايمكن إظهار جرد المخزن قبل تخصيص الهندسه',
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    );
                                                  } else {
                                                    //get store name by handasah
                                                    debugPrint(
                                                        "Store Name before get: $storeName");
                                                    debugPrint(
                                                        "Handasah Name before get: ${snapshot.data![index]['handasah_name']}");

                                                    //navigate to IntegrationWithStoresGetAllQty
                                                    await DioNetworkRepos()
                                                        .getStoreNameByHandasahName(
                                                            snapshot.data![
                                                                    index][
                                                                'handasah_name'])
                                                        .then((value) {
                                                      // setState(() {
                                                      debugPrint(
                                                          value['storeName']);
                                                      storeName =
                                                          value['storeName'];
                                                      // });
                                                    });
                                                    debugPrint(
                                                        "Store Name after get: $storeName");

                                                    //excute tempStoredProcedure
                                                    DioNetworkRepos()
                                                        .excuteTempStoreQty(
                                                            storeName);
                                                    //navigate to IntegrationWithStoresGetAllQty
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         IntegrationWithStoresGetAllQty(
                                                    //       storeName: storeName,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                    context.push(
                                                        '/integrate-with-stores/$storeName');
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.store_outlined,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'الربط مع المعامل',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.report_gmailerrorred,
                                                  color: Colors.cyan,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'تتبع سيارة GPS',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.car_rental,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip:
                                                    "غرفة الطوارئ المتحركة",
                                                hoverColor: Colors.yellow,
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         const CallerScreen(),
                                                  //   ),
                                                  // );
                                                  context.push('/caller');
                                                },
                                                icon: const Icon(
                                                  Icons.car_crash,
                                                  color: Colors.purple,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'نظام الكاميرات',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {
                                                  //
                                                  //navigate to IPCameraViewer
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         const IPCameraViewer(
                                                  //       cameraUrl:
                                                  //           'http://196.219.231.5', // replace with your actual stream URL
                                                  //     ),
                                                  //   ),
                                                  // );

                                                  //navigate to Browser
                                                  const url =
                                                      'http://196.219.231.5';
                                                  CustomBrowserRedirect
                                                      .openInBrowser(
                                                          url); // Open in browser
                                                },
                                                icon: const Icon(
                                                  Icons.video_camera_back,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'الربط مع الاسكادا',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {
                                                  //open in browser
                                                  CustomBrowserRedirect
                                                      .openInBrowser(
                                                          'http://41.33.226.211:8070/roundpoint' // Open in browser
                                                          );
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .dashboard_customize_outlined,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                tooltip: 'عرض بيانات الشكوى',
                                                hoverColor: Colors.yellow,
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CustomReusableTextAlertDialog(
                                                      title: 'بيانات العطل',
                                                      messages: [
                                                        'العنوان :  ${snapshot.data![index]['address']}',
                                                        'الاحداثئات :  ${snapshot.data![index]['latitude']} , ${snapshot.data[index]['longitude']}',
                                                        snapshot.data![index][
                                                                    'handasah_name'] ==
                                                                "free"
                                                            ? 'الهندسة: لم يتم تعيين هندسة'
                                                            : 'الهندسة :  ${snapshot.data![index]['handasah_name']}',
                                                        snapshot.data![index][
                                                                    'technical_name'] ==
                                                                "free"
                                                            ? 'اسم فنى الهندسة: لم يتم تعيين فنى الهندسة'
                                                            : 'إسم فنى الهندسة :  ${snapshot.data![index]['technical_name']}',
                                                        'Gis-Link :  ${snapshot.data![index]['gis_url']}',
                                                        'إسم المبلغ :  ${snapshot.data![index]['caller_name']}',
                                                        ' رقم هاتف المبلغ:  ${snapshot.data![index]['caller_phone']}',
                                                        'نوع الكسر :  ${snapshot.data![index]['broker_type']}',
                                                      ],
                                                      actions: [
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          child: TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: const Text(
                                                                'إغلاق'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.info,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              // physics: const NeverScrollableScrollPhysics(),
                            );
                          }
                          return const Center(
                            child: Text('لا يوجد شكاوى مفتوحة'),
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
        getLocs: getAllHotLineAddresses,
      ),
    );
  }
}
