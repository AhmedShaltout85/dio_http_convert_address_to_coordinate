// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// import 'package:data_table_2/data_table_2.dart';

import '../model/custom_data_table_source.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late CustomDataTableSource<Map<String, dynamic>> _dataSource;

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> sampleData = [
      {"id": 1, "name": "John Doe", "age": 30},
      {"id": 2, "name": "Jane Doe", "age": 25},
    ];

    _dataSource = CustomDataTableSource(
      items: sampleData,
      columns: [
        const DataColumn(label: Text("ID")),
        const DataColumn(label: Text("Name")),
        const DataColumn(label: Text("Age")),
      ],
      buildRow: (item) => DataRow(cells: [
        DataCell(Text(item["id"].toString())),
        DataCell(Text(item["name"])),
        DataCell(Text(item["age"].toString())),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // PaginatedDataTable2(
    //   columns: const [
    //     DataColumn(label: Text("ID")),
    //     DataColumn(label: Text("Name")),
    //     DataColumn(label: Text("Age")),
    //   ],
    //   source: _dataSource,
    //   rowsPerPage: 5,
    //   // dataRowColor: WidgetStateProperty.all<Color?>(
    //   //     Colors.white), // Explicitly define the type
    // );
  }
}
