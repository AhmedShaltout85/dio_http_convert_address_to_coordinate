import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_web_view_iframe.dart';

// import '../custom_widget/custom_drawer.dart';
import '../network/remote/dio_network_repos.dart';

class HandasahScreen extends StatefulWidget {
  const HandasahScreen({super.key});

  @override
  State<HandasahScreen> createState() => _HandasahScreenState();
}

class _HandasahScreenState extends State<HandasahScreen> {
  // late Future getLocs;
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     getLocs = DioNetworkRepos().getLoc();
  //   });
  //   getLocs.then((value) => debugPrint(value.toString()));
  // }

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
          'Handasah Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
          // Stack(children: [
          const IframeScreen(
              url: 'http://196.219.231.3:8000/lab-api/lab-marker/24'),
      // body: const IframeScreen(url: 'https://flutter.dev/'),
      // Align(
      //   alignment: Alignment.topLeft,
      //   child: Container(
      //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
      //     width: 250,
      //     height: MediaQuery.of(context).size.height,
      //     color: Colors.black45,
      //   ),
      // ),
      // Align(
      //   alignment: Alignment.topRight,
      //   child: Container(
      //     margin: const EdgeInsets.all(8),
      //     width: 250,
      //     height: MediaQuery.of(context).size.height,
      //     color: Colors.black45,
      //   ),
      // ),
      // ]),
      endDrawer: const Drawer(
        backgroundColor: Colors.black45,
      ),
      drawer: const Drawer(
        backgroundColor: Colors.black45,
      ),
    );
  }
}
