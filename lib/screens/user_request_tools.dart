import 'package:flutter/material.dart';

import '../custom_widget/custom_dropdown_menu.dart';
import '../network/remote/dio_network_repos.dart';

class UserRequestTools extends StatefulWidget {
  final String handasahName;
  final String address;
  final String technicianName;
  const UserRequestTools({
    super.key,
    required this.handasahName,
    required this.address,
    required this.technicianName,
  });

  @override
  State<UserRequestTools> createState() => _UserRequestToolsState();
}

class _UserRequestToolsState extends State<UserRequestTools> {
  List<String> toolsItemsDropdownMenu = [];

  //
  @override
  void initState() {
    super.initState();
    fetchHandasatItems();
  }

  void fetchHandasatItems() async {
    try {
      final List<dynamic> items =
          await DioNetworkRepos().fetchHandasatToolsItemsDropdownMenu(
              widget.handasahName);

      setState(() {
        toolsItemsDropdownMenu = items.map((e) => e.toString()).toList();
      });
      debugPrint("handasatItemsDropdownMenu from UI: $toolsItemsDropdownMenu");
    } catch (e) {
      debugPrint("Error fetching dropdown items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'طلب المهمات',
          style: TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.indigo,
          size: 17,
        ),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('طلب المهمات'),
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: CustomDropdown(
              isExpanded: false,
              items: toolsItemsDropdownMenu,
              hintText: 'اسم المهمة',
              onChanged: (value) async {
                setState(() {
                  // roleValue = value;
                  debugPrint('Selected item: $value');
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
