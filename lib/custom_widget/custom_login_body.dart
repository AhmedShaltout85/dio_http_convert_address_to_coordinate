// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:pick_location/custom_widget/custom_circle_avatar.dart';
// import 'package:pick_location/custom_widget/custom_elevated_button.dart';
// import 'package:pick_location/custom_widget/custom_text_field.dart';
// import 'package:pick_location/screens/handasah_screen.dart';
// import 'package:pick_location/screens/user_screen.dart';
// import 'package:pick_location/utils/dio_http_constants.dart';

// import '../network/remote/dio_network_repos.dart';
// import '../screens/address_to_coordinates_web.dart';
// import '../themes/themes.dart';

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

//   void handleLogin(BuildContext context) async {
//     final username = usernameController.text;
//     final password = passwordController.text;

//     if (username.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please enter both username and password')),
//       );
//       return;
//     }

//     final response = await DioNetworkRepos().login(username, password);

//     if (context.mounted) {
//       if (response['success']) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login successful!')),
//         );
//         if (DataStatic.userRole == 1) {
//           // Navigate to AddressToCoordinates screen
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const AddressToCoordinates()),
//           );
//         } else if (DataStatic.userRole == 2) {
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
//           SnackBar(content: Text('Login failed: ${response['message']}')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 60.0,
//           ),
//           const CustomCircleAvatar(
//             imgString: 'assets/logo.png',
//             width: 70,
//             height: 70,
//             radius: 70,
//           ),
//           const SizedBox(
//             height: 10.0,
//           ),
//           const Padding(
//             padding: EdgeInsets.only(top: 15, left: 25),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Login User',
//                 style: TextStyle(
//                     color: AppTheme.txtColor,
//                     fontSize: 27,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 17.0,
//           ),
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(23),
//               topRight: Radius.circular(23),
//             ),
//             child: Container(
//               color: AppTheme.txtColor,
//               height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 27.0,
//                     ),
//                     CustomTextField(
//                         controller: usernameController,
//                         keyboardType: TextInputType.text,
//                         lableText: 'Username',
//                         hintText: 'Enter Username',
//                         prefixIcon: const Icon(Icons.verified_user_outlined),
//                         suffixIcon: const SizedBox(),
//                         obscureText: false,
//                         textInputAction: TextInputAction.next),
//                     const SizedBox(
//                       height: 8.0,
//                     ),
//                     CustomTextField(
//                       controller: passwordController,
//                       keyboardType: TextInputType.text,
//                       lableText: 'Password',
//                       hintText: 'Enter Password',
//                       prefixIcon: const Icon(Icons.password),
//                       suffixIcon: const Icon(Icons.visibility),
//                       obscureText: true,
//                       textInputAction: TextInputAction.done,
//                     ),
//                     const SizedBox(
//                       height: 17.0,
//                     ),
//                     CustomElevatedButton(
//                       textString: 'login',
//                       onPressed: () async {
//                         // try {
//                         if (usernameController.text.isEmpty ||
//                             passwordController.text.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please Enter Username & Password'),
//                             ),
//                           );
//                         } else {
//                           // call login api
//                           handleLogin(context);
//                           // await handleLogins(context);
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> handleLogins(BuildContext context) async {
//     final username = usernameController.text;
//     final password = passwordController.text;

//     final success =
//         await DioNetworkRepos().loginByUsernameAndPassword(username, password);
//     if (context.mounted) {
//       if (success) {
//         // Navigate to the next page
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const AddressToCoordinates()),
//         );
//       } else {
//         // Show error
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login failed. Please try again.')),
//         );
//       }
//     }
//   }
// // }
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
  //
  // Default role selection
  String selectedOption = '0'; // Default role: مدير النظام
  String? roleValue = 'مدير النظام';

  final List<RadioOption<String>> options = [
    RadioOption(label: 'فنى هندسة', value: '3'),
    RadioOption(label: 'مديرى ومشرفى الهندسة', value: '2'),
    RadioOption(label: 'شكاوى خارجية', value: '4'),
    RadioOption(label: 'غرفة الطوارىء', value: '1'),
    RadioOption(label: 'مدير النظام', value: '0'),
  ];

  List<String> handasatItemsDropdownMenu = [];
  List<String> userItemsDropdownMenu = [];
  String? selectedUser;
  //
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
        // if (roleValue == 'غرفة الطوارىء' && DataStatic.userRole == 1) {
        if (DataStatic.userRole == 1) {
          // Navigate to AddressToCoordinates screen
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
        // } else if (roleValue == 'شكاوى خارجية' && DataStatic.userRole == 4) {
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
        // } else if (roleValue == 'مدير النظام' && DataStatic.userRole == 0) {
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
    // final username = usernameController.text;
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
        } else {
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
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth > 600
                ? 600
                : screenWidth * 0.9, // Max width for web
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomCircleAvatar(
                  imgString: 'assets/logo.png',
                  width: 100, // Larger for web
                  height: 100,
                  radius: 100,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomRadioButton<String>(
                      options: options,
                      initialValue: '0',
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
                            case '5':
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
                      textStyle:
                          const TextStyle(fontSize: 11, color: Colors.indigo),
                      radioSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (selectedOption == '3' || selectedOption == '2')
                  Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 1.0),
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
                                .fetchLoginUsersItemsDropdownMenu(2, value!);
                            //

                            debugPrint(userList.toString());
                            break;
                          case '3':
                            userList = await DioNetworkRepos()
                                .fetchLoginUsersItemsDropdownMenu(3, value!);
                            //

                            debugPrint(userList.toString());
                            break;
                        }
                        if (!mounted) return;
                        setState(() {
                          roleValue = value;
                          userItemsDropdownMenu =
                              userList.map((e) => e.toString()).toList();

                          // Reset selected value safely
                          selectedUser =
                              userItemsDropdownMenu.contains(selectedUser)
                                  ? selectedUser
                                  : (userItemsDropdownMenu.isNotEmpty
                                      ? userItemsDropdownMenu.first
                                      : null);
                        });

                        debugPrint('Selected Handasah item: $roleValue');
                        //
                      },
                    ),
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
                        selectedOption == '0' || selectedOption == '1' ||
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
                                )
                                // CustomDropdown(
                                //   isExpanded: true,
                                //   items: userList
                                //       .map((e) => e.toString())
                                //       .toList(),
                                //   hintText: 'فضلا أختر إسم المستخدم',
                                //   onChanged: (value) {
                                //     roleValueOld = value;
                                //   },
                                // ),
                                ),
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
                        selectedOption == '0' || selectedOption == '1' || selectedOption == '4'
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
