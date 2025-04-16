// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_circle_avatar.dart';
import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';
import 'package:pick_location/custom_widget/custom_elevated_button.dart';
import 'package:pick_location/custom_widget/custom_login_drop_down_menu.dart';
import 'package:pick_location/custom_widget/custom_radio_button.dart';
import 'package:pick_location/custom_widget/custom_text_field.dart';
import 'package:pick_location/screens/handasah_screen.dart';
import 'package:pick_location/screens/system_admin_screen.dart';
import 'package:pick_location/screens/user_screen.dart';
import 'package:pick_location/utils/dio_http_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../network/remote/dio_network_repos.dart';
import '../screens/address_to_coordinates_web.dart';
import '../screens/address_to_coordinates_web_other.dart';

class CustomizLoginScreenBody extends StatefulWidget {
  const CustomizLoginScreenBody({
    super.key,
  });

  @override
  State<CustomizLoginScreenBody> createState() =>
      _CustomizLoginScreenBodyState();
}

class _CustomizLoginScreenBodyState extends State<CustomizLoginScreenBody> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<dynamic> userList = [];

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? roleValueOld;
  String selectedOption = '3'; // Default to 'فنى هندسة' for mobile
  String? roleValue = 'فنى هندسة';

  // Full options list
  final List<RadioOption<String>> _fullOptions = [
    RadioOption(label: 'فنى هندسة', value: '3'),
    RadioOption(label: 'مديرى ومشرفى الهندسة', value: '2'),
    RadioOption(label: 'شكاوى خارجية', value: '4'),
    RadioOption(label: 'غرفة الطوارىء', value: '1'),
    RadioOption(label: 'مدير النظام', value: '0'),
  ];

  // Mobile-only options list
  final List<RadioOption<String>> _mobileOptions = [
    RadioOption(label: 'فنى هندسة', value: '3'),
  ];

  List<String> handasatItemsDropdownMenu = [];
  List<String> userItemsDropdownMenu = [];
  String? selectedUser;

  @override
  void initState() {
    super.initState();
    fetchHandasatItems();
  }

  void fetchHandasatItems() async {
    try {
      final List<dynamic> items =
          await DioNetworkRepos().fetchHandasatItemsDropdownMenu();

      setState(() {
        handasatItemsDropdownMenu = items.map((e) => e.toString()).toList();
      });
      debugPrint(
          "handasatItemsDropdownMenu from UI: $handasatItemsDropdownMenu");
    } catch (e) {
      debugPrint("Error fetching dropdown items: $e");
    }
  }

  // ... [keep all your existing handleLogin methods unchanged] ...
  void handleLogin(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both username and password',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    final response = await DioNetworkRepos().login(username, password);

    if (context.mounted) {
      if (response['success']) {
        if (DataStatic.userRole == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddressToCoordinates()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم تسجيل الدخول بنجاح',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (DataStatic.userRole == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddressToCoordinatesOther()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم تسجيل الدخول بنجاح',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (DataStatic.userRole == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SystemAdminScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم تسجيل الدخول بنجاح',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'فضلا, أدخل البيانات الصحيحة',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Login failed: ${response['message']}',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          )),
        );
      }
    }
  }

  void handleLoginWithDropDown(BuildContext context) async {
    final password = passwordController.text;

    if (roleValueOld == null || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both username and password',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    final response = await DioNetworkRepos().login(roleValueOld!, password);

    if (context.mounted) {
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم تسجيل الدخول بنجاح',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ),
        );

        if (DataStatic.userRole == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HandasahScreen()),
          );
        } else if (DataStatic.userRole == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login failed: ${response['message']}',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = !kIsWeb && (screenWidth < 600);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth > 600 ? 600 : screenWidth * 0.9,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomCircleAvatar(
                  imgString: 'assets/logo.png',
                  width: 100,
                  height: 100,
                  radius: 100,
                ),
                const SizedBox(height: 20),

                // Modified section for radio and dropdown
                if (isMobile)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dropdown for mobile
                        if (selectedOption == '3' || selectedOption == '2')
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.indigo, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: CustomDropdown(
                                isExpanded: true,
                                items: handasatItemsDropdownMenu,
                                hintText: 'اختر الهندسة',
                                onChanged: (value) async {
                                  userList = await DioNetworkRepos()
                                      .fetchLoginUsersItemsDropdownMenu(
                                          3, value!);
                                  if (!mounted) return;
                                  setState(() {
                                    roleValue = value;
                                    userItemsDropdownMenu = userList
                                        .map((e) => e.toString())
                                        .toList();
                                    selectedUser = userItemsDropdownMenu
                                            .contains(selectedUser)
                                        ? selectedUser
                                        : (userItemsDropdownMenu.isNotEmpty
                                            ? userItemsDropdownMenu.first
                                            : null);
                                  });
                                  debugPrint(
                                      'Selected Handasah item: $roleValue');
                                },
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        // Radio button for mobile (single option)
                        Expanded(
                          flex: 2,
                          child: CustomRadioButton<String>(
                            options: _mobileOptions,
                            initialValue: '3',
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                                roleValue = 'فنى هندسة';
                              });
                              debugPrint("Selected ROLE: $selectedOption");
                            },
                            direction: Axis.horizontal,
                            spacing: 13.0,
                            activeColor: Colors.indigo,
                            inactiveColor: Colors.grey[600],
                            textStyle: const TextStyle(
                                fontSize: 11, color: Colors.indigo),
                            radioSize: 15.0,
                          ),
                        ),
                       
                      ],
                    ),
                  )
                else
                  // Original layout for web/tablet
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CustomRadioButton<String>(
                            options: _fullOptions,
                            initialValue: '3',
                            onChanged: (value) async {
                              setState(() {
                                selectedOption = value!;
                                switch (selectedOption) {
                                  case '0':
                                    roleValue = 'مدير النظام';
                                    break;
                                  case '1':
                                    roleValue = 'غرفة الطوارىء';
                                    break;
                                  case '2':
                                    roleValue = 'مديرى ومشرفى الهندسة';
                                    break;
                                  case '3':
                                    roleValue = 'فنى هندسة';
                                    break;
                                  case '4':
                                    roleValue = 'شكاوى خارجية';
                                    break;
                                }
                              });
                              debugPrint("Selected ROLE: $selectedOption");
                            },
                            direction: Axis.horizontal,
                            spacing: 13.0,
                            activeColor: Colors.indigo,
                            inactiveColor: Colors.grey[600],
                            textStyle: const TextStyle(
                                fontSize: 11, color: Colors.indigo),
                            radioSize: 15.0,
                          ),
                        ),
                      ),
                      if (selectedOption == '3' || selectedOption == '2')
                        Container(
                          margin: const EdgeInsets.all(3.0),
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.indigo, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: CustomDropdown(
                            isExpanded: false,
                            items: handasatItemsDropdownMenu,
                            hintText: 'فضلا أختر الهندسة',
                            onChanged: (value) async {
                              switch (selectedOption) {
                                case '2':
                                  userList = await DioNetworkRepos()
                                      .fetchLoginUsersItemsDropdownMenu(
                                          2, value!);
                                  break;
                                case '3':
                                  userList = await DioNetworkRepos()
                                      .fetchLoginUsersItemsDropdownMenu(
                                          3, value!);
                                  break;
                              }
                              if (!mounted) return;
                              setState(() {
                                roleValue = value;
                                userItemsDropdownMenu =
                                    userList.map((e) => e.toString()).toList();
                                selectedUser =
                                    userItemsDropdownMenu.contains(selectedUser)
                                        ? selectedUser
                                        : (userItemsDropdownMenu.isNotEmpty
                                            ? userItemsDropdownMenu.first
                                            : null);
                              });
                              debugPrint('Selected Handasah item: $roleValue');
                            },
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.blueGrey.shade200,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        selectedOption == '0' ||
                                selectedOption == '1' ||
                                selectedOption == '4'
                            ? CustomTextField(
                                controller: usernameController,
                                keyboardType: TextInputType.text,
                                lableText: 'Username',
                                hintText: 'Enter Username',
                                prefixIcon:
                                    const Icon(Icons.verified_user_outlined),
                                suffixIcon: const SizedBox(),
                                obscureText: false,
                                textInputAction: TextInputAction.next,
                              )
                            : Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.indigo, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: CustomLoginDropdown(
                                  items: userItemsDropdownMenu,
                                  value: selectedUser,
                                  hintText: 'فضلا أختر إسم المستخدم',
                                  onChanged: (value) {
                                    roleValueOld = value;
                                  },
                                )),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          lableText: 'Password',
                          hintText: 'Enter Password',
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: const Icon(Icons.visibility),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 24),
                        selectedOption == '0' ||
                                selectedOption == '1' ||
                                selectedOption == '4'
                            ? CustomElevatedButton(
                                textString: 'Login',
                                onPressed: () async {
                                  if (usernameController.text.isEmpty ||
                                      passwordController.text.isEmpty ||
                                      roleValue == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                            'فضلا أختر نوع الحساب, وبيانات المستخدم بشكل صحيح'),
                                      ),
                                    );
                                  } else {
                                    handleLogin(context);
                                  }
                                },
                              )
                            : CustomElevatedButton(
                                textString: 'Login',
                                onPressed: () async {
                                  if (passwordController.text.isEmpty ||
                                      roleValueOld == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                            'فضلا أختر نوع الحساب, وبيانات المستخدم بشكل صحيح'),
                                      ),
                                    );
                                  } else {
                                    handleLoginWithDropDown(context);
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:pick_location/custom_widget/custom_circle_avatar.dart';
// import 'package:pick_location/custom_widget/custom_dropdown_menu.dart';
// import 'package:pick_location/custom_widget/custom_elevated_button.dart';
// import 'package:pick_location/custom_widget/custom_login_drop_down_menu.dart';
// import 'package:pick_location/custom_widget/custom_radio_button.dart';
// import 'package:pick_location/custom_widget/custom_text_field.dart';
// import 'package:pick_location/screens/handasah_screen.dart';
// import 'package:pick_location/screens/system_admin_screen.dart';
// import 'package:pick_location/screens/user_screen.dart';
// import 'package:pick_location/utils/dio_http_constants.dart';

// import '../network/remote/dio_network_repos.dart';
// import '../screens/address_to_coordinates_web.dart';
// import '../screens/address_to_coordinates_web_other.dart';

// class CustomizLoginScreenBody extends StatefulWidget {
//   const CustomizLoginScreenBody({
//     super.key,
//   });

//   @override
//   State<CustomizLoginScreenBody> createState() =>
//       _CustomizLoginScreenBodyState();
// }

// class _CustomizLoginScreenBodyState extends State<CustomizLoginScreenBody> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   List<dynamic> userList = [];

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   String? roleValueOld;
//   //
//   // Default role selection
//   String selectedOption = '0'; // Default role: مدير النظام
//   String? roleValue = 'مدير النظام';

//   final List<RadioOption<String>> options = [
//     RadioOption(label: 'فنى هندسة', value: '3'),
//     RadioOption(label: 'مديرى ومشرفى الهندسة', value: '2'),
//     RadioOption(label: 'شكاوى خارجية', value: '4'),
//     RadioOption(label: 'غرفة الطوارىء', value: '1'),
//     RadioOption(label: 'مدير النظام', value: '0'),
//   ];

//   List<String> handasatItemsDropdownMenu = [];
//   List<String> userItemsDropdownMenu = [];
//   String? selectedUser;
//   //
//   @override
//   void initState() {
//     super.initState();
//     fetchHandasatItems();
//   }

//   void fetchHandasatItems() async {
//     try {
//       final List<dynamic> items =
//           await DioNetworkRepos().fetchHandasatItemsDropdownMenu();

//       setState(() {
//         handasatItemsDropdownMenu = items.map((e) => e.toString()).toList();
//       });
//       debugPrint(
//           "handasatItemsDropdownMenu from UI: $handasatItemsDropdownMenu");
//     } catch (e) {
//       debugPrint("Error fetching dropdown items: $e");
//     }
//   }

//   void handleLogin(BuildContext context) async {
//     final username = usernameController.text;
//     final password = passwordController.text;

//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Please enter both username and password',
//             textDirection: TextDirection.ltr,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//       return;
//     }

//     final response = await DioNetworkRepos().login(username, password);

//     if (context.mounted) {
//       if (response['success']) {
//         // if (roleValue == 'غرفة الطوارىء' && DataStatic.userRole == 1) {
//         if (DataStatic.userRole == 1) {
//           // Navigate to AddressToCoordinates screen
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const AddressToCoordinates()),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'تم تسجيل الدخول بنجاح',
//                 textDirection: TextDirection.rtl,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         // } else if (roleValue == 'شكاوى خارجية' && DataStatic.userRole == 4) {
//         } else if (DataStatic.userRole == 4) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const AddressToCoordinatesOther()),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'تم تسجيل الدخول بنجاح',
//                 textDirection: TextDirection.rtl,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         // } else if (roleValue == 'مدير النظام' && DataStatic.userRole == 0) {
//         } else if (DataStatic.userRole == 0) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SystemAdminScreen()),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'تم تسجيل الدخول بنجاح',
//                 textDirection: TextDirection.rtl,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'فضلا, أدخل البيانات الصحيحة',
//                 textDirection: TextDirection.rtl,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//             'Login failed: ${response['message']}',
//             textDirection: TextDirection.rtl,
//             textAlign: TextAlign.center,
//           )),
//         );
//       }
//     }
//   }

//   void handleLoginWithDropDown(BuildContext context) async {
//     // final username = usernameController.text;
//     final password = passwordController.text;

//     if (roleValueOld == null || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             'Please enter both username and password',
//             textDirection: TextDirection.ltr,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//       return;
//     }

//     final response = await DioNetworkRepos().login(roleValueOld!, password);

//     if (context.mounted) {
//       if (response['success']) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'تم تسجيل الدخول بنجاح',
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.center,
//             ),
//           ),
//         );

//         if (DataStatic.userRole == 2) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const HandasahScreen()),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const UserScreen()),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Login failed: ${response['message']}',
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.center,
//             ),
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     // final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             width: screenWidth > 600
//                 ? 600
//                 : screenWidth * 0.9, // Max width for web
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CustomCircleAvatar(
//                   imgString: 'assets/logo.png',
//                   width: 100, // Larger for web
//                   height: 100,
//                   radius: 100,
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: CustomRadioButton<String>(
//                       options: options,
//                       initialValue: '0',
//                       onChanged: (value) async {
//                         setState(() {
//                           selectedOption = value!;
//                           switch (selectedOption) {
//                             case '0':
//                               roleValue = 'مدير النظام';
//                               break;
//                             case '1':
//                               roleValue = 'غرفة الطوارىء';
//                               break;
//                             case '2':
//                               roleValue = 'مديرى ومشرفى الهندسة';
//                               break;
//                             case '3':
//                               roleValue = 'فنى هندسة';
//                               break;
//                             case '5':
//                               roleValue = 'شكاوى خارجية';
//                               break;
//                           }
//                         });
//                         debugPrint("Selected ROLE: $selectedOption");
//                       },
//                       direction: Axis.horizontal,
//                       spacing: 13.0,
//                       activeColor: Colors.indigo,
//                       inactiveColor: Colors.grey[600],
//                       textStyle:
//                           const TextStyle(fontSize: 11, color: Colors.indigo),
//                       radioSize: 15.0,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (selectedOption == '3' || selectedOption == '2')
//                   Container(
//                     margin: const EdgeInsets.all(3.0),
//                     padding: const EdgeInsets.symmetric(horizontal: 1.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.indigo, width: 1.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: CustomDropdown(
//                       isExpanded: false,
//                       items: handasatItemsDropdownMenu,
//                       hintText: 'فضلا أختر الهندسة',
//                       onChanged: (value) async {
//                         switch (selectedOption) {
//                           case '2':
//                             userList = await DioNetworkRepos()
//                                 .fetchLoginUsersItemsDropdownMenu(2, value!);
//                             //

//                             debugPrint(userList.toString());
//                             break;
//                           case '3':
//                             userList = await DioNetworkRepos()
//                                 .fetchLoginUsersItemsDropdownMenu(3, value!);
//                             //

//                             debugPrint(userList.toString());
//                             break;
//                         }
//                         if (!mounted) return;
//                         setState(() {
//                           roleValue = value;
//                           userItemsDropdownMenu =
//                               userList.map((e) => e.toString()).toList();

//                           // Reset selected value safely
//                           selectedUser =
//                               userItemsDropdownMenu.contains(selectedUser)
//                                   ? selectedUser
//                                   : (userItemsDropdownMenu.isNotEmpty
//                                       ? userItemsDropdownMenu.first
//                                       : null);
//                         });

//                         debugPrint('Selected Handasah item: $roleValue');
//                         //
//                       },
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//                 Card(
//                   color: Colors.blueGrey.shade200,
//                   elevation: 8,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       children: [
//                         selectedOption == '0' || selectedOption == '1' ||
//                                 selectedOption == '4'
//                             ? CustomTextField(
//                                 controller: usernameController,
//                                 keyboardType: TextInputType.text,
//                                 lableText: 'Username',
//                                 hintText: 'Enter Username',
//                                 prefixIcon:
//                                     const Icon(Icons.verified_user_outlined),
//                                 suffixIcon: const SizedBox(),
//                                 obscureText: false,
//                                 textInputAction: TextInputAction.next,
//                               )
//                             : Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 30.0),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 30.0),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Colors.indigo, width: 1.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 child: CustomLoginDropdown(
//                                   items: userItemsDropdownMenu,
//                                   value: selectedUser,
//                                   hintText: 'فضلا أختر إسم المستخدم',
//                                   onChanged: (value) {
//                                     roleValueOld = value;
//                                   },
//                                 )
//                                 // CustomDropdown(
//                                 //   isExpanded: true,
//                                 //   items: userList
//                                 //       .map((e) => e.toString())
//                                 //       .toList(),
//                                 //   hintText: 'فضلا أختر إسم المستخدم',
//                                 //   onChanged: (value) {
//                                 //     roleValueOld = value;
//                                 //   },
//                                 // ),
//                                 ),
//                         const SizedBox(height: 16),
//                         CustomTextField(
//                           controller: passwordController,
//                           keyboardType: TextInputType.text,
//                           lableText: 'Password',
//                           hintText: 'Enter Password',
//                           prefixIcon: const Icon(Icons.password),
//                           suffixIcon: const Icon(Icons.visibility),
//                           obscureText: true,
//                           textInputAction: TextInputAction.done,
//                         ),
//                         const SizedBox(height: 24),
//                         selectedOption == '0' || selectedOption == '1' || selectedOption == '4'
//                             ? CustomElevatedButton(
//                                 textString: 'Login',
//                                 onPressed: () async {
//                                   if (usernameController.text.isEmpty ||
//                                       passwordController.text.isEmpty ||
//                                       roleValue == null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             textDirection: TextDirection.rtl,
//                                             textAlign: TextAlign.center,
//                                             'فضلا أختر نوع الحساب, وبيانات المستخدم بشكل صحيح'),
//                                       ),
//                                     );
//                                   } else {
//                                     handleLogin(context);
//                                   }
//                                 },
//                               )
//                             : CustomElevatedButton(
//                                 textString: 'Login',
//                                 onPressed: () async {
//                                   if (passwordController.text.isEmpty ||
//                                       roleValueOld == null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             textDirection: TextDirection.rtl,
//                                             textAlign: TextAlign.center,
//                                             'فضلا أختر نوع الحساب, وبيانات المستخدم بشكل صحيح'),
//                                       ),
//                                     );
//                                   } else {
//                                     handleLoginWithDropDown(context);
//                                   }
//                                 },
//                               ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }