import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_handasah_assign_user.dart';
import 'package:pick_location/custom_widget/custom_web_view_iframe.dart';

import '../custom_widget/custom_drawer.dart';
import '../network/remote/dio_network_repos.dart';

class HandasahScreen extends StatefulWidget {
  const HandasahScreen({super.key});

  @override
  State<HandasahScreen> createState() => _HandasahScreenState();
}

class _HandasahScreenState extends State<HandasahScreen> {
  late Future getLocsByHandasahNameAndIsFinished;
  late Future getLocByHandasahAndTechnician;

  //get handasat items dropdown menu from db
  // late Future getHandasatItemsDropdownMenu;
  // List<String> handasatItemsDropdownMenu = [];
  //get handasat users items dropdown menu from db
  late Future getHandasatUsersItemsDropdownMenu;
  List<String> handasatUsersItemsDropdownMenu = [];

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocsByHandasahNameAndIsFinished =
          DioNetworkRepos().getLocByHandasahAndIsFinished('Handasah', 0);
      getLocByHandasahAndTechnician = DioNetworkRepos()
          .getLocByHandasahAndTechnician(
              'Handasah', 'free'); //not assigned users
    });
    getLocsByHandasahNameAndIsFinished.then((value) {
      debugPrint("PRINTED FROM GETLOC FUTURE(value): $value");
      debugPrint(
          "PRINTED FROM GETLOC FUTURE(value[0]): ${value[0]['handasah_name']}");
      value.forEach((element) {
        // element['handasah_name'];
        // debugPrint("PRINTED FROM GETLOC FUTURE: $element");
        debugPrint(
            "PRINTED FROM GETLOC FUTURE(element['handasah_name']): ${element['handasah_name']}");
        //   //get handasat users items dropdown menu from db(future)
        // getHandasatItemsDropdownMenu =
        //     DioNetworkRepos().fetchHandasatUsersItemsDropdownMenu(element);
      });
    });

    //get handasat items dropdown menu from db
    // getHandasatItemsDropdownMenu =
    //     DioNetworkRepos().fetchHandasatItemsDropdownMenu();

    // //load list
    // getHandasatItemsDropdownMenu.then((value) {
    //   value.forEach((element) {
    //     element = element.toString();
    //     //add to list
    //     handasatItemsDropdownMenu.add(element);
    //   });
    //   //debug print
    //   debugPrint(
    //       "handasatItemsDropdownMenu from UI: $handasatItemsDropdownMenu");
    //   debugPrint(value.toString());
    // });

    //get handasat users items dropdown menu from db(future)
    getHandasatUsersItemsDropdownMenu =
        DioNetworkRepos().fetchHandasatUsersItemsDropdownMenu('Handasah');
    // DioNetworkRepos()
    //     .fetchHandasatUsersItemsDropdownMenu(DataStatic.handasahName);

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
      // key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 17),
        backgroundColor: Colors.indigo,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_drop_down_circle),
        //   onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        // ),
        centerTitle: true,
        title: const Text(
          'صفحة الهندسة',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: IframeScreen(
                url: 'http://196.219.231.3:8000/lab-api/lab-marker/24'),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: 250,
              height: MediaQuery.of(context).size.height,
              color: Colors.black45,
              child: CustomHandasahAssignUser(
                getLocs: getLocByHandasahAndTechnician,
                stringListItems: handasatUsersItemsDropdownMenu,
                onPressed: () {
                  setState(() {
                    getLocsByHandasahNameAndIsFinished = DioNetworkRepos()
                        .getLocByHandasahAndIsFinished('Handasah', 0);
                    getLocByHandasahAndTechnician = DioNetworkRepos()
                        .getLocByHandasahAndTechnician('Handasah', 'free');
                  });
                },
                hintText: 'فضلا أختار الموظف',
                title: 'تخصيص فنى',
              ),
            ),
          ),
        ],
      ),

      endDrawer: CustomDrawer(
        title: "جميع الكسور الخاصة بالهندسة",
        getLocs: getLocsByHandasahNameAndIsFinished,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getLocsByHandasahNameAndIsFinished =
                DioNetworkRepos().getLocByHandasahAndIsFinished('Handasah', 0);
            getLocByHandasahAndTechnician = DioNetworkRepos()
                .getLocByHandasahAndTechnician('Handasah', 'free');
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
