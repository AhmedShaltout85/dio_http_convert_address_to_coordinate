import 'package:flutter/material.dart';

class CustomDataTableSource<T> extends DataTableSource {
  final List<T> items;
  final List<DataColumn> columns;
  final DataRow Function(T) buildRow;

  CustomDataTableSource({
    required this.items,
    required this.columns,
    required this.buildRow,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return null;
    return buildRow(items[index]); // Now correctly returns a DataRow
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
