import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class PipelineList extends StatefulWidget {
  const PipelineList(
      {Key key, this.clientName, this.daysInMonth, this.salesData})
      : super(key: key);
  final List<dynamic> clientName;
  final int daysInMonth;
  final List<SalesPipeline> salesData;

  @override
  _PipelineListState createState() => _PipelineListState();
}

class _PipelineListState extends State<PipelineList> {
  var tableColumns = [];
  List<int> visitDays = [];
  List<dynamic> visitIds = [];
  Widget listWidget;
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
    visitIds = List.generate(widget.salesData.length,
        (index) => List.filled(widget.daysInMonth, dynamic),
        growable: false);
  }

  Widget _buildMonthlySalesVisitTable() {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(border: Border.all(width: 5.0)),
            height: MediaQuery.of(context).size.height - 50,
            child: HorizontalDataTable(
              leftHandSideColumnWidth: 130,
              rightHandSideColumnWidth: MediaQuery.of(context).size.width,
              isFixedHeader: true,
              headerWidgets: _getTitleWidget(),
              leftSideItemBuilder: _generateFirstColumn,
              rightSideItemBuilder: _generateVisitData,
              itemCount: widget.clientName.length,
              rowSeparatorWidget: Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
              leftHandSideColBackgroundColor: Colors.grey[400],
              rightHandSideColBackgroundColor: Colors.grey[200],
              verticalScrollbarStyle: const ScrollbarStyle(
                isAlwaysShown: true,
                thickness: 4.0,
                radius: Radius.circular(5.0),
              ),
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
        child: Text(
          'Client Name',
          style: textStyle4,
          textAlign: TextAlign.center,
        ),
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width / 6,
      ),
      for (int i = 1; i <= widget.daysInMonth; i++)
        Container(
          child: Text(
            '$i',
            style: textStyle5,
            textAlign: TextAlign.center,
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 39,
        ),
    ];
  }

  Widget _generateFirstColumn(BuildContext context, int index) {
    return Center(
      child: Container(
        child: Text(widget.clientName[index].toString(),
            style: textStyle1, textAlign: TextAlign.center),
        height: MediaQuery.of(context).size.height / 10,
        width: MediaQuery.of(context).size.width / 6,
      ),
    );
  }

  Widget _generateVisitData(BuildContext context, int index) {
    return Row(
        mainAxisSize: MainAxisSize.min, children: [_getRowVisits(index)]);
  }

  //Build widget to visit rows
  Widget _getRowVisits(int index) {
    var visits = _clientVisitsPerDay(index);
    for (int i = 0; i <= widget.daysInMonth; i++) {
      listWidget = InkWell(
        onTap: () {
          print('${widget.clientName[index]} - ${visitIds[index]} ');
        },
        child: Container(
          child: Center(
            child: visits.isNotEmpty && visits.contains(i)
                ? Icon(
                    Icons.adjust_rounded,
                    color: Colors.green,
                  )
                : Text(''),
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 39,
        ),
      );
      return listWidget;
    }
  }

  //Fill the column with the required days of the month
  _populateColumn() {
    tableColumns.add('Client Name');
    for (int i = 1; i < 30; i++) {
      tableColumns.add('$i');
    }
  }

  //will spread the client visit as per each day in the table
  _clientVisitsPerDay(int index) {
    visitDays = [];
    String client;
    //transform the date to days
    for (int k = 0; k < widget.salesData.length; k++) {
      if (widget.salesData[k].visitDate != null) {
        var date =
            DateTime.parse(widget.salesData[k].visitDate.toDate().toString());

        var day =
            int.parse(date.toLocal().toString().split(' ')[0].split('-')[2]);
        client = widget.salesData[k].clientName;
        if (widget.clientName[index] == client &&
            widget.salesData[k].salesId != null) {
          visitDays.add(day);
          // visitIds[index][index] = widget.salesData[k].salesId;
        }
      }
    }
    return visitDays;
  }
}
