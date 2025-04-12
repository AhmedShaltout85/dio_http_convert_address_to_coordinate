// import 'package:flutter/material.dart';
// import 'package:pick_location/custom_widget/custom_drop_down_menu_tools.dart';
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
//   String? selectedTool;
//   bool isLoading = false;
//   bool isSubmitting = false;
//   String? errorMessage;
//   int toolQty = 1; // Default quantity

//   @override
//   void initState() {
//     super.initState();
//     fetchHandasatItems();
//   }

//   Future<void> fetchHandasatItems() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final items = await DioNetworkRepos().fetchHandasatToolsItemsDropdownMenu(
//         widget.handasahName,
//       );

//       setState(() {
//         toolsItemsDropdownMenu = items;
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to load tools. Please try again.';
//       });
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> _submitRequest() async {
//     if (selectedTool == null || selectedTool!.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a tool first')),
//       );
//       return;
//     }

//     setState(() => isSubmitting = true);

//     try {
//       await DioNetworkRepos().createNewRequestTools(
//         handasahName: widget.handasahName,
//         toolName: selectedTool!,
//         address: widget.address,
//         techName: widget.technicianName,
//         requestStatus: 1,
//         toolQty: toolQty,
//         isApproved: 0,
//         date: DateTime.now().toIso8601String(),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'تم طلب $selectedTool بنجاح',
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );

//       // Clear selection after successful submission
//       setState(() => selectedTool = null);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => isSubmitting = false);
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
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Error message display
//             if (errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: Text(
//                   errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             // Loading indicator for tools
//             if (isLoading)
//               const Center(child: CircularProgressIndicator())
//             else
//               Column(
//                 children: [
//                   // Tool selection row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Quantity selector
//                       Flexible(
//                         flex: 1,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                           decoration: BoxDecoration(
//                             border:
//                                 Border.all(color: Colors.indigo, width: 1.0),
//                             borderRadius: BorderRadius.circular(3.0),
//                           ),
//                           child: DropdownButton<int>(
//                             value: toolQty,
//                             items: List.generate(10, (i) => i + 1)
//                                 .map((qty) => DropdownMenuItem(
//                                       value: qty,
//                                       child: Text(
//                                         '$qty',
//                                         style: const TextStyle(
//                                             color: Colors.indigo),
//                                       ),
//                                     ))
//                                 .toList(),
//                             onChanged: (value) {
//                               if (value != null) {
//                                 setState(() => toolQty = value);
//                               }
//                             },
//                           ),
//                         ),
//                       ),

//                       // Tool dropdown
//                       Flexible(
//                         flex: 3,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           decoration: BoxDecoration(
//                             border:
//                                 Border.all(color: Colors.indigo, width: 1.0),
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: toolsItemsDropdownMenu.isEmpty
//                               ? const Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 16.0),
//                                   child: Text('No tools available'),
//                                 )
//                               : CustomDropDownMenuTools(
//                                   isExpanded: false,
//                                   items: toolsItemsDropdownMenu,
//                                   hintText: 'اسم المهمة',
//                                   value: selectedTool,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedTool = value;
//                                     });
//                                   },
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Submit button
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.indigo,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 16, horizontal: 20),
//                     ),
//                     onPressed: isSubmitting ? null : _submitRequest,
//                     child: isSubmitting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             'تأكيد الطلب',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Information card
//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(30.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'الهندسة: ${widget.handasahName}',
//                             textAlign: TextAlign.right,
//                             textDirection: TextDirection.rtl,
//                             style: const TextStyle(color: Colors.indigo),
//                           ),
//                           Text(
//                             'العنوان: ${widget.address}',
//                             textAlign: TextAlign.right,
//                             textDirection: TextDirection.rtl,
//                             style: const TextStyle(color: Colors.indigo),
//                           ),
//                           Text(
//                             'الفني: ${widget.technicianName}',
//                             textAlign: TextAlign.right,
//                             textDirection: TextDirection.rtl,
//                             style: const TextStyle(color: Colors.indigo),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
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
  String? selectedTool;
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;
  int toolQty = 1;
  List<Map<String, dynamic>> requestedItems =
      []; // List to store requested items

  @override
  void initState() {
    super.initState();
    fetchHandasatItems();
  }

  Future<void> fetchHandasatItems() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final items = await DioNetworkRepos().fetchHandasatToolsItemsDropdownMenu(
        widget.handasahName,
      );

      setState(() {
        toolsItemsDropdownMenu = items;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load tools. Please try again.';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _submitRequest() async {
    if (selectedTool == null || selectedTool!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a tool first')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Add to local list before API call
      final newItem = {
        'toolName': selectedTool!,
        'quantity': toolQty,
        'date': DateTime.now(),
        'status': 'قيد الموافقة'
      };

      // First add to local list for immediate UI update
      setState(() {
        requestedItems.add(newItem);
      });

      // Then make the API call
      await DioNetworkRepos().createNewRequestTools(
        handasahName: widget.handasahName,
        toolName: selectedTool!,
        address: widget.address,
        techName: widget.technicianName,
        requestStatus: 1,
        toolQty: toolQty,
        isApproved: 0,
        date: DateTime.now().toIso8601String(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم طلب $selectedTool بنجاح',
            textAlign: TextAlign.center,
          ),
        ),
      );

      // Clear selection after successful submission
      setState(() => selectedTool = null);
    } catch (e) {
      // Remove from local list if API call fails
      setState(() {
        requestedItems.removeLast();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
      );
    } finally {
      setState(() => isSubmitting = false);
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
            // Error message display
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            // Loading indicator for tools
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  // Tool selection row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity selector
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.indigo, width: 1.0),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child: DropdownButton<int>(
                            value: toolQty,
                            items: List.generate(10, (i) => i + 1)
                                .map((qty) => DropdownMenuItem(
                                      value: qty,
                                      child: Text(
                                        '$qty',
                                        style: const TextStyle(
                                            color: Colors.indigo),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => toolQty = value);
                              }
                            },
                          ),
                        ),
                      ),

                      // Tool dropdown
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.indigo, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: toolsItemsDropdownMenu.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text('No tools available'),
                                )
                              : CustomDropDownMenuTools(
                                  isExpanded: false,
                                  items: toolsItemsDropdownMenu,
                                  hintText: 'اسم المهمة',
                                  value: selectedTool,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTool = value;
                                    });
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Submit button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                    ),
                    onPressed: isSubmitting ? null : _submitRequest,
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'تأكيد الطلب',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Information card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'الهندسة: ${widget.handasahName}',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(color: Colors.indigo),
                          ),
                          Text(
                            'العنوان: ${widget.address}',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(color: Colors.indigo),
                          ),
                          Text(
                            'الفني: ${widget.technicianName}',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(color: Colors.indigo),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Requested items list
                  if (requestedItems.isNotEmpty) ...[
                    const Text(
                      'الطلبات المضافة:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            for (var item in requestedItems)
                              ListTile(
                                title: Text(
                                  item['toolName'],
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'الكمية: ${item['quantity']} \n  الحالة: ${item['status']}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      requestedItems.remove(item);
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
