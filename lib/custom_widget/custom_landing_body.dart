// ignore_for_file: use_super_parameters

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:pick_location/model/carousel_list_items.dart';
import 'package:pick_location/screens/login_screen.dart';

import '../themes/themes.dart';

class CustomLandingBody extends StatelessWidget {
  const CustomLandingBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "شركة مياه الشرب بالاسكندرية ",
                        style: TextStyle(
                          color: AppTheme.primTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "قطاع التكنولوجيا والخدمات الرقمية",
                        style: TextStyle(
                          color: AppTheme.primTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "إدراة البرمجيات",
                        style: TextStyle(
                          color: AppTheme.primTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Image.asset('assets/aw_logo.png'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 2,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: CarouselListItems.carouselItemsList
                .map(
                  (item) => SizedBox(
                    child: Center(
                      child: Image.asset(
                        item.img,
                        fit: BoxFit.cover,
                        height: 1000,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppTheme.primColor),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Text(
                  'Login Screen',
                  style: TextStyle(color: AppTheme.txtColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
