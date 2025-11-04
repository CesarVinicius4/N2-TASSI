import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final String title1;
  final String title2;

  const DataTableWidget({required this.title1, required this.title2, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text(title1)),
          DataColumn(label: Text(title2)),
        ],
        rows: List.generate(
          10,
          (index) => DataRow(
            cells: [
              DataCell(Text('000000')),
              DataCell(Text('AEME TECNOLOGIA LTDA E')),
            ],
          ),
        ),
      ),
    );
  }
}
