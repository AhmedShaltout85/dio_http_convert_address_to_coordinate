import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';
import '../network/remote/dio_network_repos.dart';

class CustomHandasahAssignUser extends StatelessWidget {
  // Properties
  final String title;
  final Future getLocs; // Added generic type
  final List<String> stringListItems;
  final VoidCallback onPressed;
  final String hintText;
  // final void Function(String?) onChanged; //(08-02-2025-not-working as expected)

  // Constructor
  const CustomHandasahAssignUser({
    super.key,
    required this.getLocs,
    required this.stringListItems,
    required this.onPressed,
    required this.hintText,
    required this.title,
    //  required this.onChanged, //(08-02-2025-not-working as expected)
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
      
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(child: Text("No data available"));
              }
      
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index]; // Store in a variable
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            data['address'] ?? 'Unknown Address',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // subtitle: Text(
                          //   "(${data['latitude'] ?? 'N/A'}, ${data['longitude'] ?? 'N/A'})",
                          // ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: onPressed,
                              icon: const Icon(
                                Icons.call_missed_rounded,
                                color: Colors.indigo,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.indigo, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: CustomDropdown(
                                hintText: hintText,
                                items: stringListItems,
                                onChanged: (value) {
                                  if (value != null) {
                                    debugPrint('Selected item: $value');
                                    //updateLocAddHandasah
                                    DioNetworkRepos().updateLocAddTechnician(
                                      data['address'] ?? '',
                                      value,
                                    );
                                    debugPrint('updated item: $value');
                                    //
                                  } 
                                  // else if (data['handasah_name'] == value) {
                                    
                                  //   snapshot.data.remove(data['address']);
                                  //   debugPrint('removed item: $value');
                                  // }
                                },
                                // onChanged: onChanged,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
