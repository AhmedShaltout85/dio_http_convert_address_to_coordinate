// import 'package:flutter/material.dart';

// import '../custom_widget/custom_dropdown_menu.dart';
// import '../network/remote/dio_network_repos.dart';

// class UserRequestTools extends StatefulWidget {
//   final String handasahName;
//   final String address;
//   final String technicianName;
//   const UserRequestTools({
//     super.key,
//     required this.handasahName,
//     required this.address,
//     required this.technicianName,
//   });

//   @override
//   State<UserRequestTools> createState() => _UserRequestToolsState();
// }

// class _UserRequestToolsState extends State<UserRequestTools> {
//   List<String> toolsItemsDropdownMenu = [];

//   //
//   @override
//   void initState() {
//     super.initState();
//     fetchHandasatItems();
//   }

//   void fetchHandasatItems() async {
//     try {
//       final List<dynamic> items =
//           await DioNetworkRepos().fetchHandasatToolsItemsDropdownMenu(
//               widget.handasahName);

//       setState(() {
//         toolsItemsDropdownMenu = items.map((e) => e.toString()).toList();
//       });
//       debugPrint("handasatItemsDropdownMenu from UI: $toolsItemsDropdownMenu");
//     } catch (e) {
//       debugPrint("Error fetching dropdown items: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'طلب المهمات',
//           style: TextStyle(color: Colors.indigo),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.indigo,
//           size: 17,
//         ),
//       ),
//       body: Column(
//         children: [

//           Container(
//             margin: const EdgeInsets.all(3.0),
//             padding: const EdgeInsets.symmetric(horizontal: 1.0),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.indigo, width: 1.0),
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: CustomDropdown(
//               isExpanded: false,
//               items: toolsItemsDropdownMenu,
//               hintText: 'اسم المهمة',
//               onChanged: (value) async {
//                 setState(() {
//                   // roleValue = value;
//                   debugPrint('Selected item: $value');
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_drop_down_menu_tools.dart';

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
  String? selectedTool; // Make sure this is nullable
  // Initialize with empty string instead of null
  bool isLoading = false; // To handle loading state
  String? errorMessage; // To handle error messages

  @override
  void initState() {
    super.initState();
    fetchHandasatItems();
  }

  Future<void> fetchHandasatItems() async {
    setState(() => isLoading = true);

    try {
      final items = await DioNetworkRepos().fetchHandasatToolsItemsDropdownMenu(
        widget.handasahName,
      );

      setState(() {
        toolsItemsDropdownMenu = items;
        // Reset selection if current value doesn't exist in new items
        if (selectedTool != null && !items.contains(selectedTool)) {
          selectedTool = null;
        }
      });
    } catch (e) {
      setState(() => errorMessage = 'Failed to load items');
    } finally {
      setState(() => isLoading = false);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Display error message if any
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            // Loading indicator while fetching data
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              // In your UserRequestTools widget:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                      ),
                      onPressed: () async {
                        try {
                          await DioNetworkRepos().createNewRequestTools(
                            handasahName: widget.handasahName,
                            toolName: selectedTool ?? '',
                            address: widget.address,
                            technicianName: widget.technicianName,
                          );
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: const Text(
                        'إضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: toolsItemsDropdownMenu.isEmpty
                          ? const Text(
                              'Loading tools...') // Show loading/empty state
                          : CustomDropDownMenuTools(
                              isExpanded: false,
                              items: toolsItemsDropdownMenu,
                              hintText: 'اسم المهمة',
                              value:
                                  selectedTool, // Provide empty string as fallback
                              onChanged: (value) {
                                setState(() {
                                  selectedTool = value ?? '';
                                  debugPrint('Selected item: $value');
                                });
                              },
                            ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Additional information display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الهندسة: ${widget.handasahName}'),
                    Text('العنوان: ${widget.address}'),
                    Text('الفني: ${widget.technicianName}'),
                  ],
                ),
              ),
            ),

            // const Spacer(),

            // // Submit button
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.indigo,
            //     padding: const EdgeInsets.symmetric(vertical: 16),
            //   ),
            //   onPressed: () {
            //     // Handle form submission here
            //     _submitRequest();
            //   },
            //   child: const Text(
            //     'تأكيد الطلب',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _submitRequest() {
    if (selectedTool == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فضلا أنتظر جارى المهمات')),
      );
    }
    // Implement your submission logic here
    debugPrint('Submitting request for tool: $selectedTool');
    // You might want to show a dialog or navigate after submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم طلب $selectedTool بنجاح')),
    );
  }
}
