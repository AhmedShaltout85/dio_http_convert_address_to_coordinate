import 'package:flutter/material.dart';
import 'package:pick_location/labs/charts/rose_chart.dart';
import 'package:pick_location/utils/dio_http_constants.dart';

import '../model/grid_view_items.dart';
import '../widget/custom_reusable_grid_view.dart';

class DashboardChartsList extends StatelessWidget {
  final List<GridItem> gridItems = [
    GridItem(
      title: 'العكارة',
      testCode: 1,
      icon: Icons.terrain,
    ),
    GridItem(
      title: 'المنسوب',
      testCode: 1045,
      icon: Icons.person,
    ),
    GridItem(
      title: 'الأس الهيدروجيني',
      testCode: 3,
      icon: Icons.person,
    ),
    GridItem(
      title: 'الكلور الحر',
      testCode: 82,
      icon: Icons.person,
    ),
    GridItem(
      title: 'الأمونيا الحرة',
      testCode: 88,
      icon: Icons.person,
    ),
    GridItem(
      title: 'جرعة المروب المعملية',
      testCode: 1050,
      icon: Icons.person,
    ),
    GridItem(
      title: 'التوصيل الكهربي',
      testCode: 87,
      icon: Icons.person,
    ),
    GridItem(
      title: 'الكلور المتبقى',
      testCode: 82,
      icon: Icons.person,
    ),
    GridItem(
      title: 'جرعة الكلور النهائي المعملية',
      testCode: 1052,
      icon: Icons.person,
    ),
  ];

  DashboardChartsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DataStatic.labName,
          style: const TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: CustomGridView(
          items: gridItems,
          crossAxisCount: 2,
          childAspectRatio: 7.0,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
          // Optional: Custom onItemTap handler
          onItemTap: (item) {
            debugPrint('Custom handler for: ${item.title}');
            debugPrint('Custom handler for: ${item.testCode}');
            // Add custom navigation logic here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LabTestScreen(
                  labCode: DataStatic.labCode,
                  testCode: '84',
                  testName: item.title,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
