import 'dart:html';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class PipelineList extends StatefulWidget {
  const PipelineList({Key key, this.clientName}) : super(key: key);
  final List<dynamic> clientName;

  @override
  _PipelineListState createState() => _PipelineListState();
}

class _PipelineListState extends State<PipelineList> {
  var tableColumns = [];

  @override
  Widget build(BuildContext context) {
    return widget.clientName.isNotEmpty
        ? Container(
            child: _buildMonthlySalesVisitTable(),
          )
        : Center(
            child: Container(
              child:
                  Text('No clients were found for the selected sales person'),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    _populateColumn();
  }

  Widget _buildMonthlySalesVisitTable() {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(border: Border.all()),
          height: MediaQuery.of(context).size.height - 50,
          width: MediaQuery.of(context).size.width - 100,
          child: HorizontalDataTable(
            leftHandSideColumnWidth: 100,
            rightHandSideColumnWidth: MediaQuery.of(context).size.width - 100,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(),
            leftSideItemBuilder: _generateFirstColumn,
            rightSideItemBuilder: _generateVisitData,
            itemCount: widget.clientName.length,
            rowSeparatorWidget: Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
            leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
            rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
            verticalScrollbarStyle: const ScrollbarStyle(
              isAlwaysShown: true,
              thickness: 4.0,
              radius: Radius.circular(5.0),
            ),
            horizontalScrollbarStyle: const ScrollbarStyle(
              isAlwaysShown: true,
              thickness: 4.0,
              radius: Radius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  //Create the title widget
  List<Widget> _getTitleWidget() {
    return [
      Container(
        child: Text('Client Name'),
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width / 8,
      ),
      for (int i = 1; i < 20; i++)
        Container(
          child: Text('Day $i'),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 15,
        ),
    ];
  }

  Widget _generateFirstColumn(BuildContext context, int index) {
    return Center(
      child: Container(
        child: Text(widget.clientName[index].toString()),
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width / 15,
      ),
    );
  }

  Widget _generateVisitData(BuildContext context, int index) {
    return Row(children: [
      for (int i = 1; i < 20; i++)
        Container(
          child: Text('data of day: $i'),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 20,
        ),
      // Container(
      //   decoration: BoxDecoration(border: Border.all()),
      //   child: Text('data of day 1'),
      //   height: MediaQuery.of(context).size.height / 10,
      //   width: MediaQuery.of(context).size.width / 20,
      // ),
      // Container(
      //   child: Text('data of day 2'),
      //   decoration: BoxDecoration(border: Border.all()),
      //   height: MediaQuery.of(context).size.height / 10,
      //   width: MediaQuery.of(context).size.width / 20,
      // ),
      // Container(
      //   child: Text('data of day 3'),
      //   decoration: BoxDecoration(border: Border.all()),
      //   height: MediaQuery.of(context).size.height / 10,
      //   width: MediaQuery.of(context).size.width / 20,
      // ),
    ]);
  }

  //Fill the column with the required month values
  _populateColumn() {
    tableColumns.add('Client Name');
    for (int i = 1; i < 30; i++) {
      tableColumns.add('$i');
    }
  }
}
