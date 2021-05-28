import 'dart:html' as html;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class LoadCsvDataScreen extends StatefulWidget {
  final List<dynamic> file;
  final List<Map<String, dynamic>> mapList;

  const LoadCsvDataScreen({Key key, this.file, this.mapList}) : super(key: key);

  @override
  _LoadCsvDataScreenState createState() => _LoadCsvDataScreenState();
}

class _LoadCsvDataScreenState extends State<LoadCsvDataScreen> {
  bool _isUpdating = false;
  int _itemsUpdated = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV Data'),
          backgroundColor: Colors.amberAccent,
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  _isUpdating = true;
                });
                _updateDataPerItemCode();
              },
              child: Text('Update Data', style: TextStyle(color: Colors.black)),
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
          child: Center(child: Text(data)),
        ),
      );

      return widgetList;
    }).toList();
    var flat = list.expand((i) => i).toList();
    return flat;
  }

  _updateDataPerItemCode() async {
    String businessUnit;
    List<String> missingCodes = [];
    List<List<String>> csvConversionFile = [];
    //loop over the maplist
    for (var row in widget.mapList) {
      String businessLine = row['Business Line'];
      String itemCode = row['Item Code'];

      switch (businessLine) {
        case '212003':
          businessUnit = 'wood';
          break;
        case '212004':
          businessUnit = 'paint';
          break;
        case '212005':
          businessUnit = 'accessories';
          break;
        case '2120006':
          businessUnit = 'solid';
          break;
      }
      //get the item from the database
      await FirebaseFirestore.instance
          .collection(businessUnit)
          .where('itemCode', isEqualTo: itemCode)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          //Will add the codes that are missing in our database to add them later
          if (!missingCodes.contains(itemCode)) {
            missingCodes.add(itemCode);
            csvConversionFile.add(missingCodes);
          }
        } else {
          //_updateData(e.id, businessUnit, row['Inventory on Hand']);
          var result = value.docs.map((e) {
            return e;
          });
          result.forEach((element) {
            if (element.data().isNotEmpty || element.data() != null) {
              _itemsUpdated++;
              _updateData(element.id, businessUnit,
                  int.parse(row['Inventory on Hand']));
            }
          });
          return result;
        }
      }).onError((error, stackTrace) {
        print('An error occured with item ($itemCode): $error, $stackTrace');
        return error;
      }).catchError((error) {
        print('An error occured obtained data for item: $itemCode');
      });
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
                'You have updated the stock of $_itemsUpdated fields.\nThe following items aren\'t available in the database:\n$missingCodes'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(OK_BUTTON),
              ),
              TextButton(
                  onPressed: () async {
                    _createCsvFileFromList(missingCodes);
                  },
                  child: Text(DOWNLOAD_FILE))
            ],
          );
        });
  }

  //Will update the database as per collection and item code
  _updateData(String id, String businessUnit, int inventory) async {
    await FirebaseFirestore.instance
        .collection(businessUnit)
        .doc(id)
        .update({'inventoryOnHand': inventory}).onError((error, stackTrace) {
      print('Could not update data due to: $error: $stackTrace');
    });
  }

  //Create a downloadable csv file for the items that aren't available in the database
  _createCsvFileFromList(List<String> missingItems) async {
    final blob = html.Blob(missingItems);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'missing_items.csv';

    html.document.body.children.add(anchor);

    //donwload file
    anchor.click();
    //clean up
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
