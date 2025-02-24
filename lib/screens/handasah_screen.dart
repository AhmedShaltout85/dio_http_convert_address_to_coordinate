import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_handasah_assign_user.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:pick_location/custom_widget/custom_web_view_iframe.dart';

// import '../custom_widget/custom_drawer.dart';
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
                title: 'تخصيص فنى',
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
                        "loading...",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.indigo,
                        ),
                      ),
                    )
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
                        "جميع الاعطال الخاصة بالهندسة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data![index]['address'],
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: snapshot.data![index]
                                                    ['handasah_name'] ==
                                                "free" ||
                                            snapshot.data![index]
                                                    ['technical_name'] ==
                                                "free"
                                        ? const SizedBox.shrink()
                                        : Text(
                                            "(${snapshot.data![index]['handasah_name']},${snapshot.data![index]['technical_name']})"),
                                  ),
                                ),
                                onTap: () {
                                  // This assigns the selected item to gisHandasahUrl
                                  setState(() {
                                    gisHandasahUrl =
                                        snapshot.data![index]['gis_url'];
                                  });
                                },
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
          });
        },
        backgroundColor: Colors.indigo,
        mini: true,
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
