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
  late Future getLocs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocs = DioNetworkRepos().getLoc();
    });
    getLocs.then((value) => debugPrint(value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 17),
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_drop_down_circle),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        centerTitle: true,
        title: const Text(
          'Handasah Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const IframeScreen(
          url: 'http://196.219.231.3:8000/lab-api/lab-marker/24'),
      // body: const IframeScreen(url: 'https://flutter.dev/'),
      endDrawer: const Drawer(),
      drawer: const Drawer(),
      //   endDrawer:  CustomDrawer(
      //     getLocs: getLocs,
      //   ),
      //   drawer:  CustomDrawer(
      //     getLocs: getLocs,
      //   ),
      // bottomSheet: _showBottomSheet(context),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.indigo,
      //   child: const Icon(Icons.refresh),
      //   onPressed: () {
      //     setState(() {
      //       _showBottomSheet(context);
      //     });
      //   },
      // ),
    );
  }

  // _showBottomSheet(BuildContext context) {
  //   return _scaffoldKey.currentState?.showBottomSheet((context) {
  //     return const Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text('Bottom Sheet'),
  //         ListTile(
  //           title: Text('Item 1'),
  //         ),
  //         ListTile(
  //           title: Text('Item 2'),
  //         ),
  //         ListTile(
  //           title: Text('Item 3'),
  //         ),
  //         ListTile(
  //           title: Text('Item 4'),
  //         ),
  //       ],
  //     );
  //   });
  // }
}
