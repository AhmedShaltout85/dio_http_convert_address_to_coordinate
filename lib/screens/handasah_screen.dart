import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_web_view_iframe.dart';

import '../custom_widget/custom_drawer.dart';
import '../network/remote/dio_network_repos.dart';

class HandasahScreen extends StatefulWidget {
  const HandasahScreen({super.key});

  @override
  State<HandasahScreen> createState() => _HandasahScreenState();
}

class _HandasahScreenState extends State<HandasahScreen> {
  late Future getLocs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        iconTheme: const IconThemeData(color: Colors.white, size: 13),
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.add_box_rounded),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        centerTitle: true,
        title: const Text(
          'Handasah Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const IframeScreen(url: 'https://flutter.dev/'),
      endDrawer: const Drawer(),
      drawer: const Drawer(),
    //   endDrawer:  CustomDrawer(
    //     getLocs: getLocs,
    //   ),
    //   drawer:  CustomDrawer(
    //     getLocs: getLocs,
    //   ),
    );
  }
}
