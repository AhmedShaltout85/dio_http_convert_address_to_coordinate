import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';

class CustomEndDrawer extends StatelessWidget {
  final Future getLocs;
  final List<String> handasahListItems;

  const CustomEndDrawer(
      {super.key, required this.getLocs, required this.handasahListItems});

  @override
  Widget build(BuildContext context) {
    // List<String> handasahListItems = ['handasah1', 'handasah2', 'handasah3'];
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.black45,
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
                  'Addresses List With coordinates',
                  style: TextStyle(
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
                                title: Text(snapshot.data![index]['address']),
                                subtitle: Text(
                                    "${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']}"),
                              ),
                              Row(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                    //
                                    },
                                    icon: const Icon(Icons.note_add_rounded, color: Colors.indigo,),
                                  ),
                                  CustomDropdown(
                                    hintText: "اختار الهندسة",
                                    items: handasahListItems,
                                    onChanged: (value) {
                                      debugPrint(value);
                                    },
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
                }),
          ],
        ),
      ),
    );
  }
}
