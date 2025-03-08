import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_handasah_assign_user.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:pick_location/custom_widget/custom_web_view_iframe.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        // backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
        title: Text(
          DataStatic.handasahName,
          style: const TextStyle(color: Colors.indigo),
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
                      child: CircularProgressIndicator(
                        color: Colors.indigo,
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
                  FutureBuilder(
                      future: getLocsByHandasahNameAndIsFinished,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // This assigns the selected item to gisHandasahUrl
                                  setState(() {
                                    debugPrint(
                                        "Previous URL: $gisHandasahUrl"); // Debugging
                                    gisHandasahUrl =
                                        snapshot.data![index]['gis_url'];
                                    debugPrint(
                                        "New URL: $gisHandasahUrl"); // Debugging
                                  });
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          snapshot.data![index]['address'],
                                          style: const TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
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
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 1.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.green,
                                                            width: 1.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        "${snapshot.data![index]['handasah_name']}",
                                                        style: TextStyle(
                                                          fontSize: fontSize,
                                                          color: Colors.indigo,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .orange,
                                                                  width: 1.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
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
                                                                    .indigo,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 1.0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
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
                                                                    .indigo,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Row(children: [
                                                Expanded(
                                                  child: snapshot.data![index]
                                                              ['is_approved'] ==
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
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            'تم قبول الشكوى',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontSize,
                                                              color:
                                                                  Colors.indigo,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .orange,
                                                                width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            'قيد قبول الشكوى',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontSize,
                                                              color:
                                                                  Colors.indigo,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ])
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
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.store_sharp,
                                                color: Colors.cyan,
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              );
                            },
                            physics: const NeverScrollableScrollPhysics(),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getLocsByHandasahNameAndIsFinished = DioNetworkRepos()
                .getLocByHandasahAndIsFinished(handasahName, 0);
            getLocByHandasahAndTechnician = DioNetworkRepos()
                .getLocByHandasahAndTechnician(handasahName, 'free');
            gisHandasahUrl = "";
          });
        },
        backgroundColor: Colors.cyan,
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
