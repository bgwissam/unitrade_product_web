// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/file_uploader/updateDataGrid.dart';
import 'package:unitrade_web_v2/screens/authentication/wrapper.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class LoadCsvStatementData extends StatefulWidget {
  const LoadCsvStatementData({Key key, this.file, this.mapList})
      : super(key: key);

  final List<dynamic> file;
  final List<Map<String, dynamic>> mapList;
  @override
  _LoadCsvStatementDataState createState() => _LoadCsvStatementDataState();
}

class _LoadCsvStatementDataState extends State<LoadCsvStatementData> {
  bool _isUpdating = false;
  int _itemsUpdated = 0;
  int _itemsInFile = 0;
  int totalRecords = 0;

  @override
  void initState() {
    super.initState();
    totalRecords = widget.mapList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV Statement Data'),
          backgroundColor: Colors.amberAccent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    _isUpdating = true;
                  });
                  _updateDataPerRecord();
                },
                child:
                    Text('Update Data', style: TextStyle(color: Colors.black)),
              ),
            )
          ],
        ),
        body: !_isUpdating ? _buildDataDetails() : _updatingStatus());
  }

  //show a loading display while updating the stock
  _updatingStatus() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  child: Text('Please wait while data updates'),
                ),
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                      'File items: $_itemsInFile/$totalRecords | Items updated: $_itemsUpdated')),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

//Build the csv file and displays it on screen
  _buildDataDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.file.length,
            itemBuilder: (context, index) {
              return Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 2),
                ),
                children: [
                  TableRow(
                    children: _buildRow(widget.file[index]),
                  ),
                ],
              );
            }),
      ),
    );
  }

  List<Widget> _buildRow(List<String> currentRow) {
    var list = currentRow.map<List<Widget>>((data) {
      var widgetList = <Widget>[];
      widgetList.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(child: Text(data)),
          ),
        ),
      );

      return widgetList;
    }).toList();
    var flat = list.expand((i) => i).toList();
    return flat;
  }

  _updateDataPerRecord() async {
    String company = '212';

    List<String> missingClients = [];
    List<List<String>> csvConversionFile = [];
    missingClients.add('LC Number, Business Partner, Total Balance\n');
    //loop over the maplist
    for (var row in widget.mapList) {
      setState(() {
        _itemsInFile++;
      });
      String lcNumber = row['Invoice-to'];
      String clientName = row['Business Partner'];
      double totalBalance =
          double.tryParse(row['Total Balance'].toString().trim()) ?? 0.0;

      double col_0_30 =
          double.tryParse(row['0-30 Days'].toString().trim()) ?? 0.0;

      double col_31_60 =
          double.tryParse(row['31-60 Days'].toString().trim()) ?? 0.0;
      double col_61_90 =
          double.tryParse(row['61-90 Days'].toString().trim()) ?? 0.0;
      double col_91_180 =
          double.tryParse(row['91-180 Days'].toString().trim()) ?? 0.0;
      double col_180_360 =
          double.tryParse(row['180-360 Days'].toString().trim()) ?? 0.0;
      double colAbove =
          double.tryParse(row['Above 360 Days'].toString().trim()) ?? 0.0;

      if (lcNumber != null) {
        //get the item from the database
        await FirebaseFirestore.instance
            .collection('clients')
            .where('clientLcNumber', isEqualTo: lcNumber.trim())
            .get()
            .then((value) {
          if (value.docs.length == 0) {
            //Will add the codes that are missing in our database to add them later
            if (!missingClients.contains(lcNumber)) {
              missingClients.add('$lcNumber, $clientName, $totalBalance\n');
              csvConversionFile.add(missingClients);
            }
          } else {
            //_updateData(e.id, businessUnit, row['Inventory on Hand']);
            var result = value.docs.map((e) {
              return e;
            });
            //CHeck if current items exists and is not null
            result.forEach((element) {
              _updateData(
                  id: element.id,
                  company: company,
                  total: totalBalance,
                  col_0_30: col_0_30,
                  col_31_60: col_31_60,
                  col_61_90: col_61_90,
                  col_91_180: col_91_180,
                  col_181_360: col_180_360,
                  above: colAbove);
            });
            return result;
          }
        }).onError((error, stackTrace) {
          print('An error occured with item ($lcNumber): $error, $stackTrace');
          return error;
        }).catchError((error) {
          print('An error occured obtaining data for item: $lcNumber');
        });
      }
    }
    //will end the loading window once the whole file is updated
    setState(() {
      _isUpdating = false;
    });
    //Returns details on the update through a pop up window
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(UPDATE_DETAILS),
            content: Text(
                'Items updated: $_itemsUpdated fields.\n${missingClients.length - 1} items are missing from your database!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => Wrapper()),
                      (route) => false);
                },
                child: Text(OK_BUTTON),
              ),
              TextButton(
                  onPressed: () async {
                    _createCsvFileFromList(missingClients);
                  },
                  child: Text(DOWNLOAD_FILE))
            ],
          );
        });
  }

  //Will update the database as per collection and item code
  _updateData(
      {String id,
      String company,
      double total,
      double col_0_30,
      double col_31_60,
      double col_61_90,
      double col_91_180,
      double col_181_360,
      double above}) async {
    _itemsUpdated++;
    await FirebaseFirestore.instance.collection('clients').doc(id).update({
      '$company.total_balance': total,
      '$company.0 to 30': col_0_30,
      '$company.31 to 60': col_31_60,
      '$company.61 to 90': col_61_90,
      '$company.91 to 180': col_91_180,
      '$company.181 to 360': col_181_360,
      '$company.above 360': above,
    }).onError((error, stackTrace) {
      print('Could not update data due to: $error: $stackTrace');
    }).catchError((err) {
      print('The following error occured: $err');
    });
  }

  //Create a downloadable csv file for the items that aren't available in the database
  _createCsvFileFromList(List<String> missingItems) async {
    final blob = html.Blob(missingItems);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'table'
      ..download = 'missing_items.csv';

    html.document.body.children.add(anchor);

    //donwload file
    anchor.click();
    //clean up
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
