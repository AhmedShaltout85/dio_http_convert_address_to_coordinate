import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';

class CustomEndDrawer extends StatelessWidget {
  //properties
  final String title;
  final Future getLocs;
  final List<String> stringListItems;
  final VoidCallback onPressed;
  final String hintText;
  //constructor
  const CustomEndDrawer({
    super.key,
    required this.getLocs,
    required this.stringListItems,
    required this.onPressed,
    required this.hintText,
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
                      return Card(
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
                                "(${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']})",
                                // style: const TextStyle(color: Colors.indigo),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed:
                                      onPressed, //onPressed function goes here (NOT-TESTED-5-02-2025)
                                  icon: const Icon(
                                    Icons.call_missed_rounded,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.indigo, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: CustomDropdown(
                                    hintText: hintText,
                                    items: stringListItems,
                                    onChanged: (value) {
                                      debugPrint(value);
                                      debugPrint('Selected item: $value');
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
