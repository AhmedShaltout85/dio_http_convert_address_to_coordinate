import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_location/network/remote/dio_network_repos.dart';

class CustomDrawer extends StatelessWidget {
  final Future getLocs;
  final String title;
  //constructor
  const CustomDrawer({
    super.key,
    required this.getLocs,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.black45,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 50,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            FutureBuilder(
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
                              title: snapshot.data![index]['mainStreet'] ==
                                          null ||
                                      snapshot.data![index]['mainStreet'] == ""
                                  ? Text(
                                      snapshot.data![index]['street'],
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      '${snapshot.data![index]['street']} ${snapshot.data![index]['mainStreet']}',
                                      style: const TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold),
                                    ),
                              subtitle: Text(
                                '${snapshot.data[index]['id']}',
                                style: const TextStyle(color: Colors.indigo),
                              ),
                            ),
                          ),
                          onTap: () {
                            String address;
                            snapshot.data![index]['mainStreet'] == null ||
                                    snapshot.data![index]['mainStreet'] == ""
                                ? address = '${snapshot.data![index]['street']} الاسكندرية'
                                : address =
                                    '${snapshot.data[index]['street']} ${snapshot.data[index]['mainStreet']} الاسكندرية';
                            //post hotline data to local db
                            try {
                              DioNetworkRepos().postHotLineDataList(
                                id: snapshot.data[index]['id'],
                                caseReportDateTime: snapshot.data[index]
                                    ['caseReportDateTime'],
                                caseType: snapshot.data[index]['caseType'],
                                finalClosed: snapshot.data![index]
                                    ['finalClosed'],
                                mainStreet: snapshot.data![index]['mainStreet'],
                                reporterName: snapshot.data![index]
                                    ['reporterName'],
                                street: snapshot.data![index]['street'],
                                x: snapshot.data![index]['x'],
                                y: snapshot.data![index]['y'],
                                address: address,
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            //CALL API TO UPDATE LOCATION
                            //copy to clipboard
                            Clipboard.setData(
                              ClipboardData(
                                // text: widget.data[index]['address']));
                                text: snapshot.data![index]['mainStreet'] ==
                                            null ||
                                        snapshot.data![index]['mainStreet'] ==
                                            ""
                                    ? '${snapshot.data![index]['street']} الاسكندرية'
                                    : '${snapshot.data[index]['street']} ${snapshot.data[index]['mainStreet']} الاسكندرية',
                              ),
                            );
                            // Show a SnackBar to notify the user that the text is copied
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.black26,
                                content: Center(
                                  child: Text(
                                    'تم نسخ العنوان بنجاح',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                            Navigator.of(context)
                                .pop(); // This closes the drawer
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
    );
  }
}
