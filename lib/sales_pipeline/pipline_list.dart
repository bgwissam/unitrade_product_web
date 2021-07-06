import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/loading.dart';
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
  var _sizedBoxHeight = 10.0;
  int a;
  int b;
  var visitIds;
  Widget listWidget;
  SalesPipeline selectedVisit;
  String managerComments;
  List<SalesPipeline> commentList = [];
  DatabaseService db = DatabaseService();
  bool _isSaving = false;
  bool _isSendingData = false;
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
    a = widget.clientName.length;
    b = widget.daysInMonth;
    visitIds = List.generate(a, (index) => List(b), growable: false);
  }

  Widget _buildMonthlySalesVisitTable() {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
        actions: [
          TextButton(
              onPressed: () async {
                await _sendManagerComments();
              },
              child: Text(
                SEND_COMMENTS,
                style: buttonStyle3,
              ))
        ],
      ),
      body: !_isSendingData
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
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
            )
          : Loading(),
    );
  }

  //After all comments are made, this function should send them by email to the sales in charge of the clients
  Future _sendManagerComments() async {
    commentList = [];
    setState(() {
      _isSendingData = !_isSendingData;
    });
    var salesVisitId = widget.salesData.map((e) => e.uid).toList();

    for (var id in salesVisitId) {
      await db.salesPipeline.doc(id).get().then((value) {
        if (value.data()['commentsSent'] != null &&
            !value.data()['commentsSent']) {
          commentList.add(SalesPipeline(
            uid: value.id,
            clientName: value.data()['clientName'],
            managerComments: value.data()['managerComment'],
          ));
        }
      });
    }
    commentList.forEach((element) {
      print('The manager Comments: ${element.managerComments}');
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return commentList.isNotEmpty
            ? AlertDialog(
                title: Text(MANAGER_COMMENT),
                content: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: (2 * MediaQuery.of(context).size.height) / 5,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: commentList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(commentList[index].clientName ?? 'Not found'),
                        subtitle: Text(
                            commentList[index].managerComments ?? 'Not found'),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(onPressed: () async {}, child: Text(SEND_EMAIL))
                ],
              )
            : Center(
                child: Container(
                  child: Text(
                      'No Manager comments were found that were not already sent!'),
                ),
              );
      },
    );
    setState(() {
      _isSendingData = !_isSendingData;
    });
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

  //The following function will generate the row of visits made by the sales person
  Widget _generateVisitData(BuildContext context, int index) {
    var visits = _clientVisitsPerDay(index);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i <= widget.daysInMonth; i++)
          listWidget = InkWell(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: Text(
                          '${widget.clientName[index]} - $i',
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          height: 300.0,
                          width: 300,
                          child: FutureBuilder(
                            future: _generateList(visitIds[index][i]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Center(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            selectedVisit.visitPurpose
                                                    .toUpperCase() ??
                                                'No Record',
                                            style: textStyle1,
                                          ),
                                          SizedBox(
                                            height: _sizedBoxHeight,
                                          ),
                                          Text(
                                            selectedVisit.purposeValue
                                                    .toString() ??
                                                'No Record',
                                            style: textStyle1,
                                          ),
                                          SizedBox(
                                            height: _sizedBoxHeight,
                                          ),
                                          Text(
                                            selectedVisit.visitDetails
                                                    .toString() ??
                                                'Visit details seems not to be entered',
                                            style: textStyle1,
                                          ),
                                          SizedBox(
                                            height: _sizedBoxHeight,
                                          ),
                                          TextFormField(
                                            initialValue:
                                                selectedVisit.managerComments,
                                            autofocus: false,
                                            style: textStyle1,
                                            maxLines: 4,
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: MANAGER_COMMENT,
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (val) {
                                              managerComments = val;
                                            },
                                          ),
                                          SizedBox(
                                            height: _sizedBoxHeight,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.blueGrey,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0))),
                                                onPressed: () async {
                                                  setState(() {
                                                    _isSaving = !_isSaving;
                                                  });

                                                  managerComments == null
                                                      ? await db.salesPipeline
                                                          .add({
                                                          'managerComment':
                                                              managerComments,
                                                          'commentsSent': false,
                                                        })
                                                      : await db.salesPipeline
                                                          .doc(visitIds[index]
                                                              [i])
                                                          .update({
                                                          'managerComment':
                                                              managerComments,
                                                          'commentsSent': false,
                                                        });
                                                  setState(() {
                                                    _isSaving = !_isSaving;
                                                  });
                                                },
                                                child: !_isSaving
                                                    ? Text(ADD_COMMENT)
                                                    : CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2.0,
                                                      )),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Container(
                                    child: Text(snapshot.error.toString()),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    });
                  });
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
          )
      ],
    );
  }

  //Build widget to visit rows
  Future _generateList(String salesVisitId) async {
    await db.salesPipeline.doc(salesVisitId).get().then((value) {
      selectedVisit = SalesPipeline(
          visitPurpose: value.data()['visitPurpose'],
          visitDetails: value.data()['visitDetails'],
          purposeValue: value.data()['purposeValue'],
          managerComments: value.data()['managerComment']);
    });
    return selectedVisit;
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

        int day =
            int.parse(date.toLocal().toString().split(' ')[0].split('-')[2]);
        client = widget.salesData[k].clientName;
        if (widget.clientName[index] == client &&
            widget.salesData[k].salesId != null) {
          visitDays.add(day);
          visitIds[index][day] = '${widget.salesData[k].uid}';
        }
      }
    }
    return visitDays;
  }
}
