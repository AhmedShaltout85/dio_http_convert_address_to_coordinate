import 'package:pick_location/network/remote/dio_network_repos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDrawer extends StatelessWidget {
  final Future getLocs;
  const CustomDrawer({super.key, required this.getLocs});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
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
                  'Pick an Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            RefreshIndicator(
              //TODO: add refresh indicator here NOT TESTED(27-10-2024)
              onRefresh: () async {
                  await DioNetworkRepos().getLoc();
              },
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
                                      style: TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }
}
