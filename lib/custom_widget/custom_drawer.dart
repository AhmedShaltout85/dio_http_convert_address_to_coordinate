import 'package:flutter/material.dart';

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
            FutureBuilder(
                future: getLocs,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                                snapshot.data![index]['address']),
                            subtitle: Text(
                                "${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']}"),
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
