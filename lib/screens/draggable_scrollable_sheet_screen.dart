import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_location/screens/address_details.dart';
import 'package:pick_location/screens/agora_video_call.dart';
import 'package:pick_location/screens/tracking.dart';

import '../custom_widget/custom_browser_redirect.dart';
import '../custom_widget/custom_draggable_scrollable_sheet.dart';
import '../custom_widget/custom_web_view.dart';

class DraggableScrollableSheetScreen extends StatefulWidget {
  final Future getLocs;

  const DraggableScrollableSheetScreen({super.key, required this.getLocs});

  @override
  State<DraggableScrollableSheetScreen> createState() =>
      _DraggableScrollableSheetScreenState();
}

class _DraggableScrollableSheetScreenState
    extends State<DraggableScrollableSheetScreen> {
  // late Future getLocs;

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     getLocs = DioNetworkRepos().getLoc();
  //   });
  //   getLocs.then((value) => debugPrint(value.toString()));
  // }

  @override
  Widget build(BuildContext context) {
    return
        //  Scaffold(
        // body:
        // Stack(
        //   children: [
        // const Center(
        //   child: Text('Google Map | Gis Map'),
        // ),
        CustomDraggableScrollableSheet(
      minExtent: 0.2,
      maxExtent: 0.8,
      builder: (context, extent) {
        return Column(
          children: [
            Container(
              height: 30,
              alignment: Alignment.center,
              child: const Icon(Icons.drag_handle),
            ),
            Expanded(
              child: FutureBuilder(
                  future: widget.getLocs,
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
                                    title:
                                        Text(snapshot.data![index]['address']),
                                    subtitle: Text(
                                        "${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']}"),
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            debugPrint(
                                                "Start Gis Map ${snapshot.data![index]['gis_url']}");
                                            //open in browser
                                            // CustomBrowserRedirect.openInBrowser(
                                            //   snapshot.data![index]['gis_url'],
                                            // );
                                            //open in webview
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomWebView(
                                                  title: 'GIS Map webview',
                                                  url: snapshot.data![index]
                                                      ['gis_url'],
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
                                                builder: (context) =>
                                                    const Tracking(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.location_searching,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            onTap: () {
                              debugPrint("${snapshot.data[index]['id']}");
                              // open address details
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddressDetails(),
                                ),
                              );
                          
                              //CALL API TO UPDATE LOCATION
                              // id = widget.data[index]['id'];
                              //copy to clipboard
                              // Clipboard.setData(ClipboardData(
                              //     // text: widget.data[index]['address']));
                              //     text: snapshot.data[index]['address']));
                              // // Show a SnackBar to notify the user that the text is copied
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     backgroundColor: Colors.black26,
                              //     content: Center(
                              //       child: Text(
                              //         'تم نسخ العنوان بنجاح',
                              //         style: TextStyle(color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              // );
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
            ),
          ],
        );
      },
      // ),
      //   ],
      // ),
    );
  }
}
