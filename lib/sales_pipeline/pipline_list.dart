import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/client.dart';

class PipelineList extends StatefulWidget {
  @override
  _PipelineListState createState() => _PipelineListState();
}

class _PipelineListState extends State<PipelineList> {
  var provider;
  var tableRows = ['Saeed Al Shahrani', 'went today', 'did not go', 'did go'];
  var tableColumns = ['Client Name', '1', '2', '3'];
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<List<SalesPipeline>>(context);
    print('The provider: $provider');
    return Container(
      child: _buildMonthlySalesVisitTable(),
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
        (index) => DataRow(
          cells: List<DataCell>.generate(
            tableColumns.length,
            (index) => DataCell(
              Text(tableRows[index]),
            ),
          ),
        ),
      ),
    );
  }
}
