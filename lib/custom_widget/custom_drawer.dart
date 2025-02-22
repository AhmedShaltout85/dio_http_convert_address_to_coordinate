import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                              title: Text(
                                snapshot.data![index]['address'],
                                style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: snapshot.data![index]
                              //                 ['handasah_name'] ==
                              //             "free" ||
                              //         snapshot.data![index]['technical_name'] ==
                              //             "free"
                              //     ? const SizedBox.shrink()
                              //     : Text(
                              //         "(${snapshot.data![index]['handasah_name']},${snapshot.data![index]['technical_name']})"),
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
