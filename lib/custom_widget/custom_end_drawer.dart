import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';
import '../network/remote/dio_network_repos.dart';

class CustomEndDrawer extends StatelessWidget {
  // Properties
  final String title;
  final Future getLocs; // Added generic type
  final List<String> stringListItems;
  final VoidCallback onPressed;
  final String hintText;

  // Constructor
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
                            subtitle: Text(
                              "(${data['latitude'] ?? 'N/A'}, ${data['longitude'] ?? 'N/A'})",
                            ),
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
                                      DioNetworkRepos().updateLocAddHandasah(
                                        data['address'] ?? '',
                                        value,
                                      );
                                    }
                                  },
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
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';

// import '../network/remote/dio_network_repos.dart';

// class CustomEndDrawer extends StatelessWidget {
//   //properties
//   final String title;
//   final Future getLocs;
//   final List<String> stringListItems;
//   final VoidCallback onPressed;
//   final String hintText;
//   //constructor
//   const CustomEndDrawer({
//     super.key,
//     required this.getLocs,
//     required this.stringListItems,
//     required this.onPressed,
//     required this.hintText,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Drawer(
//         backgroundColor: Colors.black45,
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             SizedBox(
//               height: 50,
//               child: DrawerHeader(
//                 decoration: const BoxDecoration(
//                   color: Colors.indigo,
//                 ),
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ),
//             FutureBuilder(
//               future: getLocs,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       // DataStatic.handasahName =
//                       //     snapshot.data![index]['handasah_name'];
//                       return Card(
//                         child: Column(
//                           children: [
//                             ListTile(
//                               title: Text(
//                                 snapshot.data![index]['address'],
//                                 style: const TextStyle(
//                                     color: Colors.indigo,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 "(${snapshot.data![index]['latitude']},${snapshot.data![index]['longitude']})",
//                                 // style: const TextStyle(color: Colors.indigo),
//                               ),
//                               // leading:
//                               //     snapshot.data![index]['handasah_name'] == null
//                               //         ? const SizedBox.shrink()
//                               //         : Text(
//                               //             '${snapshot.data![index]['handasah_name']}',
//                               //           ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                   onPressed:
//                                       onPressed, //onPressed function goes here (NOT-TESTED-5-02-2025)
//                                   icon: const Icon(
//                                     Icons.call_missed_rounded,
//                                     color: Colors.indigo,
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.all(10.0),
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 7.0),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.indigo, width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: CustomDropdown(
//                                     hintText: hintText,
//                                     items: stringListItems,
//                                     onChanged: (value) {
//                                       // DataStatic.handasahName = value;
//                                       debugPrint(value);
//                                       debugPrint('Selected item: $value');
//                                       //updateLocAddHandasah
                                      
//                                       DioNetworkRepos().updateLocAddHandasah(
//                                         snapshot.data![index]['address'],
//                                         snapshot.data![index]['longitude'],
//                                         snapshot.data![index]['latitude'],
//                                         value!,
//                                         snapshot.data![index]['gis_url'],
//                                       );
//                                       //updateLocAddHandasah
//                                       // debugPrint(
//                                       //     'Selected item from Static var: ${DataStatic.handasahName}');
//                                     },
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     physics: const NeverScrollableScrollPhysics(),
//                   );
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';

// class CustomEndDrawer extends StatelessWidget {
//   final String title;
//   final Future getLocs;
//   final List<String> stringListItems;
//   final VoidCallback onPressed;
//   final String hintText;

//   const CustomEndDrawer({
//     super.key,
//     required this.getLocs,
//     required this.stringListItems,
//     required this.onPressed,
//     required this.hintText,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Drawer(
//         backgroundColor: Colors.black45,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 50,
//               child: DrawerHeader(
//                 decoration: const BoxDecoration(
//                   color: Colors.indigo,
//                 ),
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder(
//                 future: getLocs,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text("No data available"));
//                   }

//                   return ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       var location = snapshot.data![index];

//                       return Card(
//                         child: Column(
//                           children: [
//                             ListTile(
//                               title: Text(
//                                 location['address'] ?? 'Unknown Address',
//                                 style: const TextStyle(
//                                   color: Colors.indigo,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 "(${location['latitude'] ?? 'N/A'}, ${location['longitude'] ?? 'N/A'})",
//                               ),
//                               leading: location['handasah_name'] != null
//                                   ? Text('${location['handasah_name']}')
//                                   : const SizedBox.shrink(),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                   onPressed: onPressed,
//                                   icon: const Icon(
//                                     Icons.call_missed_rounded,
//                                     color: Colors.indigo,
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.all(10.0),
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 7.0),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.indigo, width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: CustomDropdown(
//                                     hintText: hintText,
//                                     items: stringListItems,
//                                     onChanged: (value) {
//                                       debugPrint('Selected item: $value');
//                                     },
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
