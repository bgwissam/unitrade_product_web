import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class PipelineGrid extends StatefulWidget {
  @override
  _PipelineGridState createState() => _PipelineGridState();
}

class _PipelineGridState extends State<PipelineGrid> {
  var tableRows = ['Saeed Al Shahrani', 'went today', 'did not go', 'did go'];
  var tableColumns = ['Client Name', '1', '2', '3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
      ),
      body: _buildMonthlySalesVisitTable(),
    );
  }

  Widget _buildMonthlySalesVisitTable() {
    return DataTable(
      columns: List<DataColumn>.generate(
        tableColumns.length,
        (index) => DataColumn(
          label: Text(
            tableColumns[index].toString(),
          ),
        ),
      ),
      rows: List<DataRow>.generate(
        tableRows.length,
        (index) => DataRow(cells: <DataCell>[
          DataCell(
            Text(
              tableRows[index].toString(),
            ),
          ),
        ]),
      ),
    );
  }
}
