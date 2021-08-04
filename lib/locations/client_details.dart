import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'dart:js' as js;

class ClientDetails extends StatefulWidget {
  const ClientDetails({Key key, this.clientName, this.clientId, this.visitList})
      : super(key: key);
  final String clientName;
  final String clientId;
  final List<dynamic> visitList;

  @override
  _ClientDetailsState createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  DatabaseService db = DatabaseService();
  int quoteNumber;
  final _elevation = 3.0;
  var salesId = [];
  var _sizedBoxHeight = 15.0;
  List<String> pdfUrl = [];
  List<SalesPipeline> visitDetailsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clientName),
        backgroundColor: Colors.amberAccent,
      ),
      body: _buildClientDetailsWindow(),
    );
  }

  Widget _buildClientDetailsWindow() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            width: MediaQuery.of(context).size.width - 50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Visit List: ${widget.visitList.length}',
                        style: textStyle4,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width / 4,
                      child: ListView.builder(
                        itemCount: widget.visitList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[100],
                                    title: Text(
                                      '${visitDetailsList[index].clientName} - ${visitDetailsList[index].visitDate.toDate().toString().split(' ')[0]}',
                                      style: textStyle4,
                                    ),
                                    content: Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12.0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                color: Colors.grey[300]),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Visit Purpose: ${visitDetailsList[index].visitPurpose}',
                                                    style: textStyle1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: _sizedBoxHeight,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Visit Details: ${visitDetailsList[index].visitDetails}',
                                                    style: textStyle1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: _sizedBoxHeight * 2,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(12.0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                4,
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: Colors.grey[300]),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Purpose Label: ${visitDetailsList[index].purposeLabel}',
                                                    style: textStyle1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: _sizedBoxHeight,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Purpose Value: ${visitDetailsList[index].purposeValue}',
                                                    style: textStyle1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: _elevation,
                              child: Center(
                                child: FutureBuilder(
                                    future: db.salesPipeline
                                        .doc(widget.visitList[index])
                                        .get()
                                        .catchError((error, stackTrace) async {
                                      print(
                                          'An error obtaining visit items occured: $error');
                                      throw error;
                                    }),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          visitDetailsList.add(SalesPipeline(
                                            clientName:
                                                snapshot.data['clientName'],
                                            visitDate:
                                                snapshot.data['currentDate'],
                                            visitDetails:
                                                snapshot.data['visitDetails'],
                                            visitPurpose:
                                                snapshot.data['visitPurpose'],
                                            purposeLabel:
                                                snapshot.data['purposeLabel'],
                                            purposeValue:
                                                snapshot.data['purposeValue'],
                                            clientId: snapshot.data['clientId'],
                                          ));
                                          salesId.add(snapshot.data.id);
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(
                                              snapshot.data['currentDate']
                                                  .toDate()
                                                  .toString()
                                                  .split(' ')[0],
                                              style: textStyle1,
                                            ),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            child: LinearProgressIndicator(),
                                          );
                                        } else {
                                          return Container(
                                            child: Text(
                                                'An issue occured, visits loading failed'),
                                          );
                                        }
                                      } else if (snapshot.hasError) {
                                        return Container(
                                          child:
                                              Text(snapshot.error.toString()),
                                        );
                                      } else {
                                        return Container(
                                          child: LinearProgressIndicator(),
                                        );
                                      }
                                    }),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //Will build the list of quotes for each client allowing you to view the quote from here
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width / 3,
                      child: FutureBuilder(
                        future: db.quotationCollection
                            .where('clientId', isEqualTo: widget.clientId)
                            .get()
                            .then((value) => value.docs.map((e) {
                                  pdfUrl.add(e.data()['pdfUrl']);
                                  return QuoteData(
                                    quoteId: e.data()['quoteId'],
                                    itemQuoted: e.data()['itemsQuoted'],
                                    clientName: e.data()['clientName'],
                                    paymentTerms: e.data()['paymentTerms'],
                                    status: e.data()['status'],
                                    pdfUrl: e.data()['pdfUrl'],
                                    userId: e.data()['userId'],
                                  );
                                }).toList())
                            .catchError((error, stackTrace) async {
                          print('An error obtaining quotes occured: $error');
                          throw error;
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var quoteList = snapshot.data.reversed.toList();
                              pdfUrl = pdfUrl.reversed.toList();
                              quoteNumber = quoteList.length;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Quote List: ${quoteNumber.toString()}',
                                      style: textStyle4,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: ListView.builder(
                                      itemCount: quoteList.length,
                                      itemBuilder: (context, index) {
                                        Color _cardColor;
                                        switch (quoteList[index].status) {
                                          case 'WON':
                                            _cardColor = Colors.green;
                                            break;
                                          case 'LOST':
                                            _cardColor = Colors.red;
                                            break;
                                          case 'Pending':
                                            _cardColor = Colors.yellow;
                                            break;
                                          default:
                                            _cardColor = Colors.grey;
                                        }
                                        return Center(
                                          child: Card(
                                            color: _cardColor,
                                            elevation: _elevation,
                                            child: InkWell(
                                              onTap: () {
                                                js.context.callMethod(
                                                    'open', [pdfUrl[index]]);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(12.0),
                                                child: Text(
                                                    quoteList[index]
                                                        .quoteId
                                                        .toString(),
                                                    style: textStyle1),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                child: LinearProgressIndicator(),
                              );
                            } else {
                              return Container(
                                child: Text(
                                    'An issue occured, quote loading failed'),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Container(
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            return Container(
                              child: LinearProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //create another column for additional data
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       height: 100,
            //       width: 100,
            //       child: Text('Now nothing'),
            //       decoration: BoxDecoration(border: Border.all()),
            //     )
            //   ],
            // )
          ),
        ),
      ),
    );
  }
}
