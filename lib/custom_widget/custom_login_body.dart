// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pick_location/custom_widget/custom_circle_avatar.dart';
import 'package:pick_location/custom_widget/custom_elevated_button.dart';
import 'package:pick_location/custom_widget/custom_text_field.dart';
// import 'package:pick_location/screens/gis_map.dart';

import '../network/remote/dio_network_repos.dart';
import '../screens/gis_map.dart';
import '../themes/themes.dart';

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

  void handleLogin(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both username and password')),
      );
      return;
    }

    final response = await DioNetworkRepos().login(username, password);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Navigate to another screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GisMap()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 40.0,
          ),
          const CustomCircleAvatar(
            imgString: 'assets/logo.png',
            width: 70,
            height: 70,
            radius: 70,
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15, left: 25),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Login User',
                style: TextStyle(
                    color: AppTheme.txtColor,
                    fontSize: 27,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 17.0,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
            ),
            child: Container(
              color: AppTheme.txtColor,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 27.0,
                    ),
                    CustomTextField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        lableText: 'username',
                        hintText: 'enter_user_name',
                        prefixIcon: const Icon(Icons.verified_user_outlined),
                        suffixIcon: const SizedBox(),
                        obscureText: false,
                        textInputAction: TextInputAction.next),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CustomTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      lableText: 'password',
                      hintText: 'enter_password',
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: const Icon(Icons.visibility),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 17.0,
                    ),
                    CustomElevatedButton(
                      textString: 'login',
                      onPressed: () async {
                        // try {
                        if (usernameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter username & password'),
                            ),
                          );
                        } else {
                          // call login api
                          handleLogin(context);
                          // await handleLogins(context);
                          }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleLogins(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    
    final success = await DioNetworkRepos()
        .loginByUsernameAndPassword(
      username,
      password
    
    );
    if (success) {
      // Navigate to the next page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GisMap()),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Login failed. Please try again.')),
      );
    }
  }
}
