import 'package:flutter/material.dart';
import 'package:pick_location/screens/agora_video_call.dart';
import 'package:pick_location/screens/tracking.dart';

import '../custom_widget/custom_web_view.dart';
import '../network/remote/dio_network_repos.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<Map<String, dynamic>>> getUsersBrokenPointsList;

  @override
  void initState() {
    super.initState();
    setState(() {
      //get handasat users items list from db
      getUsersBrokenPointsList = DioNetworkRepos()
          .fetchHandasatUsersItemsBroken('handasah', 'user', 0);
    });
    getUsersBrokenPointsList
        .then((value) => debugPrint("PRINTED DATA FROM UI: $value"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Screen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: FutureBuilder(
          future: getUsersBrokenPointsList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              snapshot.data![index]['address'],
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "(${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']})"),
                          ),
                          snapshot.data![index]['handasah_name'] == null
                              ? const SizedBox.shrink()
                              : ListTile(
                                  title: Text(
                                    '${snapshot.data![index]['handasah_name']}, (${snapshot.data![index]['technical_name']})',
                                    style:
                                        const TextStyle(color: Colors.indigo),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
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
                                  // CustomBrowserRedirect.openInBrowser(
                                  //   snapshot.data![index]['gis_url'],
                                  // );
                                  //open in webview
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomWebView(
                                        title: 'GIS Map webview',
                                        url: snapshot.data![index]['gis_url'],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.open_in_browser,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  debugPrint(
                                      "Start Video Call ${snapshot.data![index]['id']}");
                                  //open video call
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AgoraVideoCall(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.video_call,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  debugPrint(
                                      "Start Traking ${snapshot.data![index]['id']}");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Tracking(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    //update is_finished(close broken locations)
                                    DioNetworkRepos().updateLocAddIsFinished(
                                        snapshot.data![index]['address'], 1);
                                  });
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          setState(() {
            //get handasat users items list from db
            getUsersBrokenPointsList = DioNetworkRepos()
                .fetchHandasatUsersItemsBroken('handasah', 'user', 0);
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
