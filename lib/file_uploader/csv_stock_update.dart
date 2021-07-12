// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/screens/authentication/wrapper.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class LoadCsvStockData extends StatefulWidget {
  final List<dynamic> file;
  final List<Map<String, dynamic>> mapList;

  const LoadCsvStockData({Key key, this.file, this.mapList}) : super(key: key);

  @override
  _LoadCsvStockDataState createState() => _LoadCsvStockDataState();
}

class _LoadCsvStockDataState extends State<LoadCsvStockData> {
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

  _updateDataPerItemCode() async {
    String businessUnit;
    List<String> missingCodes = [];
    List<List<String>> csvConversionFile = [];
    missingCodes
        .add('Item Code, Business Line, Description, Inventory on Hand\n');
    //loop over the maplist
    for (var row in widget.mapList) {
      setState(() {
        _itemsInFile++;
      });
      String businessLine = row['Business Line'];
      String description = row['Description'];
      String itemCode = row['Item Code'];
      String city = row['City'];
      String brand = row['Vendor'];
      String inv = row['Inventory on Hand'];
      if (city != null && city.trim() == 'RIYADH' ||
          city.trim() == 'KHO' ||
          city.trim() == 'JED') {
        switch (businessLine) {
          case '212003':
            businessUnit = 'wood';
            break;
          case '212004':
            if (brand != 'LARIUS')
              businessUnit = 'paint';
            else
              businessUnit = 'machines';
            break;
          case '212005':
            businessUnit = 'accessories';
            break;
          case '212006':
            businessUnit = 'solid';
            break;
          default:
            businessUnit = null;
        }
        if (businessUnit != null) {
          //get the item from the database
          await FirebaseFirestore.instance
              .collection(businessUnit)
              .where('itemCode', isEqualTo: itemCode.trim())
              .get()
              .then((value) {
            if (value.docs.length == 0) {
              //Will add the codes that are missing in our database to add them later
              if (!missingCodes.contains(itemCode)) {
                missingCodes
                    .add('$itemCode, $businessLine, $description, $inv\n');
                csvConversionFile.add(missingCodes);
              }
            } else {
              //_updateData(e.id, businessUnit, row['Inventory on Hand']);
              var result = value.docs.map((e) {
                return e;
              });
              result.forEach((element) {
                var invMap = new Map();
                if (element.data()['inventory'] != null) {
                  invMap = element.data()['inventory'];

                  //check if map contains key
                  if (invMap.containsKey(city)) {
                    //If the current inventory doesn't match the one in the database
                    if (inv != invMap[city].toString()) {
                      setState(() {
                        _itemsUpdated++;
                      });
                      _updateData(
                          element.id, businessUnit, int.parse(inv), city);
                    }
                  }
                  //If current key doesn't match any key in our database
                  else {
                    setState(() {
                      _itemsUpdated++;
                    });
                    _updateData(element.id, businessUnit, int.parse(inv), city);
                  }
                } else {
                  //Add the field to the current item code
                  _updateData(element.id, businessUnit, int.parse(inv), city);
                }
              });
              return result;
            }
          }).onError((error, stackTrace) {
            print(
                'An error occured with item ($itemCode): $error, $stackTrace');
            return error;
          }).catchError((error) {
            print('An error occured obtaining data for item: $itemCode');
          });
        }
      } //end if city check if else statement
      else {
        _showDialogPlatform('City Field Issue',
            'The city field should contain either RIYADH, KHO, or JED. Any other value will not be accepted');
        break;
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
                'Items updated: $_itemsUpdated fields.\n${missingCodes.length} items are missing from your database!'),
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
                    _createCsvFileFromList(missingCodes);
                  },
                  child: Text(DOWNLOAD_FILE))
            ],
          );
        });
  }

  //Will update the database as per collection and item code
  _updateData(
      String id, String businessUnit, int inventory, String city) async {
    await FirebaseFirestore.instance
        .collection(businessUnit)
        .doc(id)
        .update({'inventory.$city': inventory}).onError((error, stackTrace) {
      print('Could not update data due to: $error: $stackTrace');
    }).catchError((err) {
      print('The following error occured: $err');
      throw err;
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

  Widget _showDialogPlatform(String title, String content) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(OK_BUTTON),
              ),
            ],
          );
        });
  }
}
