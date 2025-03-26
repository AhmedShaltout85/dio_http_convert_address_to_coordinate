import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_text_field.dart';

import '../custom_widget/custom_dropdown_menu.dart';
import '../custom_widget/custom_elevated_button.dart';
import '../custom_widget/custom_radio_button.dart';
import '../network/remote/dio_network_repos.dart';

class SystemAdminScreen extends StatefulWidget {
  const SystemAdminScreen({super.key});

  @override
  State<SystemAdminScreen> createState() => _SystemAdminScreenState();
}

class _SystemAdminScreenState extends State<SystemAdminScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  //Radio Button
  String? selectedOption;

  final List<RadioOption<String>> options = [
    RadioOption(label: 'فنى هندسة', value: '3'),
    RadioOption(label: 'مديرى ومشرفى الهندسة', value: '2'),
    RadioOption(label: 'غرفة الطوارىء', value: '1'),
    RadioOption(label: 'مدير النظام', value: '0'),
  ];

//get handsahat items dropdown menu
  late Future getHandasatItemsDropdownMenu;

  List<String> handasatItemsDropdownMenu = [
    // 'مدير النظام',
    // 'غرفة الطوارىء',
    // 'مديرى ومشرفى الهندسة',
    // 'فنى هندسة'
  ];

  String? roleValue;
  var role = 3;

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //get handasat items dropdown menu from db
      getHandasatItemsDropdownMenu =
          DioNetworkRepos().fetchHandasatItemsDropdownMenu();

      //load list
      getHandasatItemsDropdownMenu.then((value) {
        value.forEach((element) {
          element = element.toString();
          //add to list
          handasatItemsDropdownMenu.add(element);
        });
        //debug print
        debugPrint(
            "handasatItemsDropdownMenu from UI: $handasatItemsDropdownMenu");
        debugPrint(value.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 7,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo, size: 17),
        title: const Text(
          'مدير النظام',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Row(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              width: 200,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              child: SizedBox(
                child: Column(
                  children: [
                    const Text(
                      'إضافة مستخدم جديد',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      lableText: 'Username',
                      hintText: 'Enter Username',
                      prefixIcon: const Icon(Icons.verified_user_outlined),
                      suffixIcon: const SizedBox(),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      lableText: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: const Icon(Icons.password_rounded),
                      suffixIcon: const SizedBox.shrink(),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      lableText: 'Confirm Password',
                      hintText: 'Please Confirm Password',
                      prefixIcon: const Icon(Icons.password_rounded),
                      suffixIcon: const SizedBox.shrink(),
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomRadioButton<String>(
                        options: options,
                        initialValue: '0',
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });

                          debugPrint("Selected: $selectedOption");
                        },
                        direction: Axis
                            .horizontal, // Change to Axis.horizontal for horizontal layout
                        spacing: 16.0,
                        activeColor: Colors.indigo,
                        inactiveColor: Colors.grey[600],
                        textStyle:
                            const TextStyle(fontSize: 13, color: Colors.indigo),
                        radioSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    selectedOption == '3' || selectedOption == '2'
                        ? Container(
                            margin: const EdgeInsets.all(3.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.indigo, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: CustomDropdown(
                              isExpanded: false,
                              items: handasatItemsDropdownMenu,
                              hintText: 'فضلا أختر الهندسة',
                              onChanged: (value) {
                                roleValue = value;
                                debugPrint(
                                    'Selected Handasat item: $roleValue');

                                // if (value == 'مدير النظام') {
                                //   role = 0;
                                // } else if (value == 'غرفة الطوارىء') {
                                //   role = 1;
                                // } else if (value == 'مديرى ومشرفى الهندسة') {
                                //   role = 2;
                                // } else if (value == 'فنى هندسة') {
                                //   role = 3;
                                // }
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      textString: 'حفظ',
                      onPressed: () {
                        //
                        if (usernameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty && 
                            passwordController.text == confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please Enter Username & Matched Password'),
                            ),
                          );
                        } else {
                          // call create new user
                          DioNetworkRepos().createNewUser(
                            usernameController.text,
                            passwordController.text,
                            int.parse(selectedOption!),
                            roleValue!,
                          );
                          //
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم انشاء المستخدم بنجاح',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          //
                          usernameController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(
              width: 200,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
