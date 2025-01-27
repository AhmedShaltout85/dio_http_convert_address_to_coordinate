import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../custom_widget/custom_draggable_scrollable_sheet.dart';
import '../network/remote/dio_network_repos.dart';

class DraggableScrollableSheetScreen extends StatefulWidget {
  const DraggableScrollableSheetScreen({super.key});

  @override
  State<DraggableScrollableSheetScreen> createState() =>
      _DraggableScrollableSheetScreenState();
}

class _DraggableScrollableSheetScreenState
    extends State<DraggableScrollableSheetScreen> {
  late Future getLocs;

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
                        future: getLocs,
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
                                          snapshot.data![index]['address']),
                                      subtitle: Text(
                                          "${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']}"),
                                    ),
                                  ),
                                  onTap: () {
                                    debugPrint("${snapshot.data[index]['id']}");
                                    //CALL API TO UPDATE LOCATION
                                    // id = widget.data[index]['id'];
                                    //copy to clipboard
                                    Clipboard.setData(ClipboardData(
                                        // text: widget.data[index]['address']));
                                        text: snapshot.data[index]['address']));
                                    // Show a SnackBar to notify the user that the text is copied
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.black26,
                                        content: Center(
                                          child: Text(
                                            'Text copied to clipboard!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
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
