// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_alert_dialog_create_handasah_users.dart';
import 'package:pick_location/custom_widget/custom_handasah_assign_user.dart';
import 'package:pick_location/screens/integration_with_stores_get_all_qty.dart';
import 'package:pick_location/screens/request_tool_for_address_screen.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:pick_location/custom_widget/custom_web_view_iframe.dart';

import '../custom_widget/custom_reusable_alert_dailog.dart';
import '../custom_widget/cutom_texts_alert_dailog.dart';
import '../network/remote/dio_network_repos.dart';

class HandasahScreen extends StatefulWidget {
  const HandasahScreen({super.key});

  @override
  State<HandasahScreen> createState() => _HandasahScreenState();
}

class _HandasahScreenState extends State<HandasahScreen> {
  late Future getLocsByHandasahNameAndIsFinished;
  late Future getLocByHandasahAndTechnician;
  String handasahName = DataStatic.handasahName;
  String gisHandasahUrl = "";

  //get handasat items dropdown menu from db
  // late Future getHandasatItemsDropdownMenu;
  // List<String> handasatItemsDropdownMenu = [];
  //get handasat users items dropdown menu from db
  late Future getHandasatUsersItemsDropdownMenu;
  List<String> handasatUsersItemsDropdownMenu = [];
  double fontSize = 12.0;
  String storeName = "";
  Timer? _timer; // Timer for periodic fetching
  int length = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      //
      getLocsByHandasahNameAndIsFinished =
          DioNetworkRepos().getLocByHandasahAndIsFinished(handasahName, 0);
      //
      getLocByHandasahAndTechnician = DioNetworkRepos()
          .getLocByHandasahAndTechnician(
              handasahName, 'free'); //not assigned users
      //
    });
    getLocsByHandasahNameAndIsFinished.then((value) {
      debugPrint("PRINTED FROM GETLOC FUTURE(value): $value");
      debugPrint(
          "PRINTED FROM GETLOC FUTURE(value[0]): ${value[0]['handasah_name']}");
      value.forEach((element) {
        debugPrint(
            "PRINTED FROM GETLOC FUTURE(element['handasah_name']): ${element['handasah_name']}");
      });
    });

    //get handasat users items dropdown menu from db(future)
    getHandasatUsersItemsDropdownMenu =
        DioNetworkRepos().fetchHandasatUsersItemsDropdownMenu(handasahName);

    //load list(future)
    getHandasatUsersItemsDropdownMenu.then((value) {
      value.forEach((element) {
        element = element.toString();
        //add to list(strings)
        handasatUsersItemsDropdownMenu.add(element);
      });
      //debug print
      debugPrint(
          "handasatItemsDropdownMenu from UI: $handasatUsersItemsDropdownMenu");
      debugPrint(value.toString());
    });
    //
    _startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel periodic fetch and location update timer
    // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void _startPeriodicFetch() {
    const Duration fetchInterval =
        Duration(seconds: 10); // Fetch every 10 seconds
    _timer = Timer.periodic(fetchInterval, (Timer timer) {
      setState(() {
        getLocsByHandasahNameAndIsFinished =
            DioNetworkRepos().getLocByHandasahAndIsFinished(handasahName, 0);
        getLocByHandasahAndTechnician = DioNetworkRepos()
            .getLocByHandasahAndTechnician(handasahName, 'free');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
        title: Text(
          DataStatic.handasahName,
          style: const TextStyle(color: Colors.indigo),
        ),
        actions: [
          IconButton(
            tooltip: "إضافة مشرف, وفنى الهندسة",
            hoverColor: Colors.yellow,
            icon: const Icon(
              Icons.person_add_alt,
              color: Colors.indigo,
            ),
            onPressed: () {
              //show add user dialog
              showDialog(
                  context: context,
                  builder: (context) {
                    return const CustomAlertDialogCreateHandasahUsers(
                      title: 'إضافة مستخدمين لمديرى ومشرفى وفنين الهندسة',
                    );
                  });
            },
          ),
          IconButton(
            tooltip: "إضافه المهمات الخاصة بالهندسة",
            hoverColor: Colors.yellow,
            icon: const Icon(
              Icons.note_add_outlined,
              color: Colors.indigo,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomReusableAlertDialog(
                        title: "إضافة مهمات الهندسة",
                        fieldLabels: const [
                          'المسمى',
                          'العدد',
                        ],
                        onSubmit: (values) {
                          try {
                            DioNetworkRepos().createNewHandasahTools(
                                handasahName, values[0], int.parse(values[1]));
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        });
                  });
              debugPrint("$handasahName admin : Added new tool");
            },
          ),
        ],
      ),
      body:
          // length > 0
          //     ?
          Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: 220,
              height: MediaQuery.of(context).size.height,
              color: Colors.black38,
              child: CustomHandasahAssignUser(
                getLocs: getLocByHandasahAndTechnician,
                stringListItems: handasatUsersItemsDropdownMenu,
                onPressed: () {
                  setState(() {
                    getLocsByHandasahNameAndIsFinished = DioNetworkRepos()
                        .getLocByHandasahAndIsFinished(handasahName, 0);
                    getLocByHandasahAndTechnician = DioNetworkRepos()
                        .getLocByHandasahAndTechnician(handasahName, 'free');
                  });
                },
                hintText: 'فضلا أختار الفنى',
                title: 'تخصيص شكوى لفنى',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: gisHandasahUrl == ""
                  ? const Center(
                      child: Text(
                        'عرض رابط GIS',
                        style: TextStyle(fontSize: 20, color: Colors.indigo),
                      ),
                    )
                  // : Container()
                  : IframeScreen(
                      url: gisHandasahUrl,
                    ), //
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: 220,
              height: MediaQuery.of(context).size.height,
              color: Colors.black38,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 50,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                      ),
                      child: Text(
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        "الشكاوى غير مغلقة الخاصة بالهندسة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  // FutureBuilder(
                  //     future: getLocsByHandasahNameAndIsFinished,
                  //     builder: (context, snapshot) {
                  //       length = snapshot.data!.length;
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       } else if (snapshot.connectionState ==
                  //           ConnectionState.done) {
                  //         if (snapshot.hasData) {
                  //           return ListView.builder(
                  //             reverse: true,
                  //             shrinkWrap: true,
                  //             itemCount: snapshot.data!.length,
                  //             itemBuilder: (context, index) {
                  //               return InkWell(
                  //                 onTap: () {
                  //                   // This assigns the selected item to gisHandasahUrl
                  //                   setState(() {
                  //                     debugPrint(
                  //                         "Previous URL: $gisHandasahUrl"); // Debugging
                  //                     gisHandasahUrl =
                  //                         snapshot.data![index]['gis_url'];
                  //                     debugPrint(
                  //                         "New URL: $gisHandasahUrl"); // Debugging
                  //                   });
                  //                 },
                  //                 child: Card(
                  //                   child: Column(
                  //                     children: [
                  //                       ListTile(
                  //                         title: Text(
                  //                           textAlign: TextAlign.center,
                  //                           snapshot.data![index]['address'],
                  //                           style: const TextStyle(
                  //                               color: Colors.indigo,
                  //                               fontSize: 12,
                  //                               fontWeight: FontWeight.bold),
                  //                         ),
                  //                         subtitle: Padding(
                  //                           padding: const EdgeInsets.symmetric(
                  //                               vertical: 7.0, horizontal: 3.0),
                  //                           child: Column(
                  //                             children: [
                  //                               Row(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .spaceBetween,
                  //                                 children: [
                  //                                   Expanded(
                  //                                     child: Container(
                  //                                       margin: const EdgeInsets
                  //                                           .all(3.0),
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .symmetric(
                  //                                               horizontal:
                  //                                                   1.0),
                  //                                       decoration:
                  //                                           BoxDecoration(
                  //                                         border: Border.all(
                  //                                             color:
                  //                                                 Colors.green,
                  //                                             width: 1.0),
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(
                  //                                                     5.0),
                  //                                       ),
                  //                                       child: Text(
                  //                                         textAlign:
                  //                                             TextAlign.center,
                  //                                         "${snapshot.data![index]['handasah_name']}",
                  //                                         style: TextStyle(
                  //                                           fontSize: fontSize,
                  //                                           color:
                  //                                               Colors.indigo,
                  //                                           fontWeight:
                  //                                               FontWeight.bold,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   snapshot.data![index][
                  //                                               'technical_name'] ==
                  //                                           "free"
                  //                                       ? Expanded(
                  //                                           child: Container(
                  //                                             margin:
                  //                                                 const EdgeInsets
                  //                                                     .all(3.0),
                  //                                             padding:
                  //                                                 const EdgeInsets
                  //                                                     .symmetric(
                  //                                                     horizontal:
                  //                                                         3.0),
                  //                                             decoration:
                  //                                                 BoxDecoration(
                  //                                               border: Border.all(
                  //                                                   color: Colors
                  //                                                       .orange,
                  //                                                   width: 1.0),
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           5.0),
                  //                                             ),
                  //                                             child: Text(
                  //                                               "قيد تخصيص فنى",
                  //                                               style:
                  //                                                   TextStyle(
                  //                                                 overflow:
                  //                                                     TextOverflow
                  //                                                         .visible,
                  //                                                 fontSize:
                  //                                                     fontSize,
                  //                                                 color: Colors
                  //                                                     .indigo,
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .bold,
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         )
                  //                                       : Expanded(
                  //                                           child: Container(
                  //                                             margin:
                  //                                                 const EdgeInsets
                  //                                                     .all(3.0),
                  //                                             padding:
                  //                                                 const EdgeInsets
                  //                                                     .symmetric(
                  //                                                     horizontal:
                  //                                                         3.0),
                  //                                             decoration:
                  //                                                 BoxDecoration(
                  //                                               border: Border.all(
                  //                                                   color: Colors
                  //                                                       .green,
                  //                                                   width: 1.0),
                  //                                               borderRadius:
                  //                                                   BorderRadius
                  //                                                       .circular(
                  //                                                           5.0),
                  //                                             ),
                  //                                             child: Text(
                  //                                               textAlign:
                  //                                                   TextAlign
                  //                                                       .center,
                  //                                               "${snapshot.data![index]['technical_name']}",
                  //                                               style:
                  //                                                   TextStyle(
                  //                                                 fontSize:
                  //                                                     fontSize,
                  //                                                 color: Colors
                  //                                                     .indigo,
                  //                                                 fontWeight:
                  //                                                     FontWeight
                  //                                                         .bold,
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                 ],
                  //                               ),
                  //                               Row(children: [
                  //                                 Expanded(
                  //                                   child: snapshot.data![index]
                  //                                               [
                  //                                               'is_approved'] ==
                  //                                           1
                  //                                       ? Container(
                  //                                           margin:
                  //                                               const EdgeInsets
                  //                                                   .all(3.0),
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                   .symmetric(
                  //                                                   horizontal:
                  //                                                       3.0),
                  //                                           decoration:
                  //                                               BoxDecoration(
                  //                                             border: Border.all(
                  //                                                 color: Colors
                  //                                                     .green,
                  //                                                 width: 1.0),
                  //                                             borderRadius:
                  //                                                 BorderRadius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                           ),
                  //                                           child: Text(
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             'تم قبول الشكوى',
                  //                                             style: TextStyle(
                  //                                               fontSize:
                  //                                                   fontSize,
                  //                                               color: Colors
                  //                                                   .indigo,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .bold,
                  //                                             ),
                  //                                           ),
                  //                                         )
                  //                                       : Container(
                  //                                           margin:
                  //                                               const EdgeInsets
                  //                                                   .all(3.0),
                  //                                           padding:
                  //                                               const EdgeInsets
                  //                                                   .symmetric(
                  //                                                   horizontal:
                  //                                                       3.0),
                  //                                           decoration:
                  //                                               BoxDecoration(
                  //                                             border: Border.all(
                  //                                                 color: Colors
                  //                                                     .orange,
                  //                                                 width: 1.0),
                  //                                             borderRadius:
                  //                                                 BorderRadius
                  //                                                     .circular(
                  //                                                         5.0),
                  //                                           ),
                  //                                           child: Text(
                  //                                             textAlign:
                  //                                                 TextAlign
                  //                                                     .center,
                  //                                             'قيد قبول الشكوى',
                  //                                             style: TextStyle(
                  //                                               fontSize:
                  //                                                   fontSize,
                  //                                               color: Colors
                  //                                                   .indigo,
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .bold,
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                 ),
                  //                               ])
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Row(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           children: [
                  //                             IconButton(
                  //                               tooltip: 'إبلاغ كسورات معامل',
                  //                               hoverColor: Colors.yellow,
                  //                               onPressed: () {},
                  //                               icon: const Icon(
                  //                                 Icons.report_gmailerrorred,
                  //                                 color: Colors.purple,
                  //                               ),
                  //                             ),
                  //                             IconButton(
                  //                               tooltip: 'مهمات مخازن مطلوبة',
                  //                               hoverColor: Colors.yellow,
                  //                               onPressed: () {},
                  //                               icon: const Icon(
                  //                                 Icons.store_sharp,
                  //                                 color: Colors.cyan,
                  //                               ),
                  //                             ),
                  //                             IconButton(
                  //                               tooltip: 'جرد مخزن',
                  //                               hoverColor: Colors.yellow,
                  //                               onPressed: () async {
                  //                                 //get store name by handasah
                  //                                 debugPrint(
                  //                                     "Store Name before get: $storeName");
                  //                                 debugPrint(
                  //                                     "Handasah Name before get: ${snapshot.data![index]['handasah_name']}");
                  //                                 await DioNetworkRepos()
                  //                                     .getStoreNameByHandasahName(
                  //                                         snapshot.data![index]
                  //                                             ['handasah_name'])
                  //                                     .then((value) {
                  //                                   // setState(() {
                  //                                   debugPrint(
                  //                                       value['storeName']);
                  //                                   storeName =
                  //                                       value['storeName'];
                  //                                   // });
                  //                                 });
                  //                                 debugPrint(
                  //                                     "Store Name after get: $storeName");
                  //                                 //excute tempStoredProcedure
                  //                                 DioNetworkRepos()
                  //                                     .excuteTempStoreQty(
                  //                                         storeName);

                  //                                 //     //navigate to IntegrationWithStoresGetAllQty
                  //                                 Navigator.push(
                  //                                   context,
                  //                                   MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         IntegrationWithStoresGetAllQty(
                  //                                       storeName: storeName,
                  //                                     ),
                  //                                   ),
                  //                                 );
                  //                               },
                  //                               icon: const Icon(
                  //                                 Icons.store_outlined,
                  //                                 color: Colors.indigo,
                  //                               ),
                  //                             ),
                  //                             IconButton(
                  //                               tooltip: 'عرض بيانات الشكوى',
                  //                               hoverColor: Colors.yellow,
                  //                               onPressed: () {
                  //                                 showDialog(
                  //                                   context: context,
                  //                                   builder: (context) =>
                  //                                       CustomReusableTextAlertDialog(
                  //                                     title: 'بيانات العطل',
                  //                                     messages: [
                  //                                       'العنوان :  ${snapshot.data[index]['address']}',
                  //                                       'الاحداثئات :  ${snapshot.data[index]['latitude']} , ${snapshot.data[index]['longitude']}',
                  //                                       'الهندسة :  ${snapshot.data[index]['handasah_name']}',
                  //                                       'إسم فنى الهندسة :  ${snapshot.data[index]['technical_name']}',
                  //                                       'رابط :  ${snapshot.data[index]['gis_url']}',
                  //                                       'إسم المبلغ :  ${snapshot.data[index]['caller_name']}',
                  //                                       ' رقم هاتف المبلغ:  ${snapshot.data[index]['caller_phone']}',
                  //                                       'نوع الكسر :  ${snapshot.data[index]['broker_type']}',
                  //                                     ],
                  //                                     actions: [
                  //                                       Align(
                  //                                         alignment: Alignment
                  //                                             .bottomLeft,
                  //                                         child: TextButton(
                  //                                           onPressed: () =>
                  //                                               Navigator.of(
                  //                                                       context)
                  //                                                   .pop(),
                  //                                           child: const Text(
                  //                                               'Close'),
                  //                                         ),
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 );
                  //                               },
                  //                               icon: const Icon(
                  //                                 Icons.info,
                  //                                 color: Colors.blueAccent,
                  //                               ),
                  //                             ),
                  //                           ]),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //             physics: const NeverScrollableScrollPhysics(),
                  //           );
                  //         }
                  //       } else if (snapshot.hasError) {
                  //         return Text('Error: ${snapshot.error}');
                  //       }
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }),
                  FutureBuilder(
                    future: getLocsByHandasahNameAndIsFinished,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Update length only if data is available
                          length = snapshot.data!.length;
                          return ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    debugPrint("Previous URL: $gisHandasahUrl");
                                    gisHandasahUrl =
                                        snapshot.data![index]['gis_url'];
                                    debugPrint("New URL: $gisHandasahUrl");
                                  });
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          textAlign: TextAlign.center,
                                          snapshot.data![index]['address'],
                                          style: const TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 7.0,
                                            horizontal: 3.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 1.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.green,
                                                            width: 1.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: Colors.green),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        "${snapshot.data![index]['handasah_name']}",
                                                        style: TextStyle(
                                                          fontSize: fontSize,
                                                          color: Colors.white,
                                                          // fontWeight:
                                                          //     FontWeight.bold,
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
                                                              horizontal: 3.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .orange,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            child: Text(
                                                              "قيد تخصيص فنى",
                                                              style: TextStyle(
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
                                                              horizontal: 3.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              "${snapshot.data![index]['technical_name']}",
                                                              style: TextStyle(
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
                                                    child: snapshot.data![index]
                                                                [
                                                                'is_approved'] ==
                                                            1
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 3.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              'تم قبول الشكوى',
                                                              style: TextStyle(
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
                                                              horizontal: 3.0,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .orange,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              'قيد قبول الشكوى',
                                                              style: TextStyle(
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            tooltip: 'إبلاغ كسورات معامل',
                                            hoverColor: Colors.yellow,
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.report_gmailerrorred,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'مهمات مخازن مطلوبة',
                                            hoverColor: Colors.yellow,
                                            onPressed: () {
                                              //nav request for user request tools tasks
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RequestToolForAddressScreen(
                                                    address:
                                                        snapshot.data![index]
                                                            ['address'],
                                                    handasahName:
                                                        snapshot.data![index]
                                                            ['handasah_name'],
                                                  ),
                                                ),
                                              );
                                              //request for store tasks
                                             
                                            },
                                            icon: const Icon(
                                              Icons.store_sharp,
                                              color: Colors.cyan,
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'جرد مخزن',
                                            hoverColor: Colors.yellow,
                                            onPressed: () async {
                                              //get store name by handasah
                                              debugPrint(
                                                  "Store Name before get: $storeName");
                                              debugPrint(
                                                  "Handasah Name before get: ${snapshot.data![index]['handasah_name']}");
                                              await DioNetworkRepos()
                                                  .getStoreNameByHandasahName(
                                                      snapshot.data![index]
                                                          ['handasah_name'])
                                                  .then((value) {
                                                debugPrint(value['storeName']);
                                                storeName = value['storeName'];
                                              });
                                              debugPrint(
                                                  "Store Name after get: $storeName");
                                              //excute tempStoredProcedure
                                              DioNetworkRepos()
                                                  .excuteTempStoreQty(
                                                      storeName);

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
                                            tooltip: 'عرض بيانات الشكوى',
                                            hoverColor: Colors.yellow,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CustomReusableTextAlertDialog(
                                                  title: 'بيانات العطل',
                                                  messages: [
                                                    'العنوان :  ${snapshot.data[index]['address']}',
                                                    'الاحداثئات :  ${snapshot.data[index]['latitude']} , ${snapshot.data[index]['longitude']}',
                                                    'الهندسة :  ${snapshot.data[index]['handasah_name']}',
                                                    'إسم فنى الهندسة :  ${snapshot.data[index]['technical_name']}',
                                                    'رابط :  ${snapshot.data[index]['gis_url']}',
                                                    'إسم المبلغ :  ${snapshot.data[index]['caller_name']}',
                                                    ' رقم هاتف المبلغ:  ${snapshot.data[index]['caller_phone']}',
                                                    'نوع الكسر :  ${snapshot.data[index]['broker_type']}',
                                                  ],
                                                  actions: [
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child:
                                                            const Text('Close'),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            physics: const NeverScrollableScrollPhysics(),
                          );
                        } else {
                          return const Center(
                            child: Text('لايوجد شكاوى مفتوحة'),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       getLocsByHandasahNameAndIsFinished = DioNetworkRepos()
      //           .getLocByHandasahAndIsFinished(handasahName, 0);
      //       getLocByHandasahAndTechnician = DioNetworkRepos()
      //           .getLocByHandasahAndTechnician(handasahName, 'free');
      //       gisHandasahUrl = "";
      //     });
      //   },
      //   backgroundColor: Colors.cyan,
      //   mini: true,
      //   tooltip: 'تحديث',
      //   child: const Icon(
      //     Icons.refresh,
      //     color: Colors.white,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }
}
