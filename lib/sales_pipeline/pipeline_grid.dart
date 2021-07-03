import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/sales_pipeline/pipline_list.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class PipelineGrid extends StatefulWidget {
  const PipelineGrid(
      {Key key,
      this.salesId,
      this.selectedYear,
      this.selectedMonth,
      this.daysInMonth})
      : super(key: key);
  final String salesId;
  final String selectedYear;
  final int selectedMonth;
  final int daysInMonth;

  @override
  _PipelineGridState createState() => _PipelineGridState();
}

class _PipelineGridState extends State<PipelineGrid> {
  Future clientList;
  @override
  void initState() {
    super.initState();
    clientList = _buildListViewClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
      ),
      body: FutureBuilder(
        future: clientList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                var salesData = await _convertStringToDate();
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => PipelineList(
                              clientName: snapshot.data,
                              daysInMonth: widget.daysInMonth,
                              salesData: salesData,
                            )));
              });
              return Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else if (snapshot.hasError) {
            return Container(
              child: Text(snapshot.error),
            );
          } else {
            return Center(
                child: Container(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }

  _convertStringToDate() async {
    String month = '';
    if (widget.selectedMonth < 10) {
      month = '0${widget.selectedMonth}';
    } else {
      month = '${widget.selectedMonth}';
    }
    //This will convert the required date from the home page to DateTime data
    DateTime startingDate =
        DateTime.parse('${widget.selectedYear}-$month-01 00:00:00');
    DateTime endingDate = DateTime.parse(
        '${widget.selectedYear}-$month-${widget.daysInMonth} 00:00:00');

    print('The date Range is: $startingDate - $endingDate');

    //will obtain the sales visits for the selected user and the date range
    DatabaseService db = DatabaseService();

    var result = await db.salesPipeline
        .where('userId', isEqualTo: widget.salesId)
        .where('currentDate', isGreaterThanOrEqualTo: startingDate)
        .where('currentDate', isLessThanOrEqualTo: endingDate)
        .get()
        .then((value) {
      return value.docs.map((e) {
        return SalesPipeline(
            clientId: e.data()['clientId'],
            clientName: e.data()['clientName'],
            visitPurpose: e.data()['visitPurpose'],
            visitDate: e.data()['currentDate'],
            purposeLabel: e.data()['purposeLabel'],
            purposeValue: e.data()['purposeValue'],
            visitDetails: e.data()['visitDetails']);
      }).toList();
    });
    return result;
  }

  Future _buildListViewClients() async {
    var result = await DatabaseService()
        .clientCollection
        .where('salesInCharge', isEqualTo: widget.salesId)
        .get()
        .then(
            (value) => value.docs.map((e) => e.data()['clientName']).toList());
    return result;
  }
}
