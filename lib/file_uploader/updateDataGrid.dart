import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:unitrade_web_v2/file_uploader/csv_client_statement_update.dart';
import 'package:unitrade_web_v2/file_uploader/csv_new_current_item_update.dart';
import 'package:unitrade_web_v2/file_uploader/csv_price_update.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/string.dart';

import 'csv_stock_update.dart';

class UpdateDataGrid extends StatefulWidget {
  final bool isAdmin;

  const UpdateDataGrid({Key key, this.isAdmin}) : super(key: key);
  @override
  _UpdateDataGridState createState() => _UpdateDataGridState();
}

class _UpdateDataGridState extends State<UpdateDataGrid> {
  var _sizedBoxHeight = 10.0;
  double height = 20;
  double width = 10;
  var _elevation = 2.0;
  bool adminUser = false;
  List csvFileContentList = [];
  List csvFileModuleList = [];
  PlatformFile csvPlatformFile;
  String _csvFileHeader;
  List<Map<String, dynamic>> csvMapList = [];
  var animationDuration = 600;
  @override
  void initState() {
    super.initState();
    adminUser = widget.isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DATA_PAGE_UPDATE),
        elevation: 5.0,
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: AnimationLimiter(
          child: GridView.count(
            primary: false,
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            mainAxisSpacing: 50,
            crossAxisSpacing: 110,
            shrinkWrap: true,
            children: [
              //Update Stock
              AnimationConfiguration.staggeredGrid(
                position: 0,
                duration: Duration(milliseconds: animationDuration),
                columnCount: 4,
                child: FadeInAnimation(
                  child: Container(
                    height: height,
                    width: width,
                    child: Card(
                      elevation: _elevation,
                      child: InkWell(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                alignment: Alignment.bottomLeft,
                                color: Colors.amberAccent,
                                child: Text(UPDATE_STOCK,
                                    style: textStyle2,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Divider(
                              height: 3.0,
                              thickness: 3.0,
                              color: Colors.black,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.white,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                    'Allows to update the stock levels for items entered in the database, however great caution should be considered by following the instractions the follow.',
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                        onTap: adminUser
                            ? () async {
                                csvFileContentList.clear();
                                csvFileModuleList.clear();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Essential Requirements'),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Needed CSV Header elements:',
                                                  style: textStyle6,
                                                ),
                                              ),
                                              SizedBox(
                                                height: _sizedBoxHeight / 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Business Line',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('Item Code',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('Inventory on Hand',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('Vendor',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('City',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                ],
                                              ),
                                              SizedBox(
                                                height: _sizedBoxHeight / 2,
                                              ),
                                              Container(
                                                  child: Text(
                                                      'The city column should containe only:',
                                                      style: textStyle6)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('RIYADH',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('KHO',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('JED',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await loadCSVFromStorage(
                                                    newCurrentItemUpdate: false,
                                                    stockUpdate: true,
                                                    priceUpdate: false,
                                                    clientBalanceUpdate: false);
                                              },
                                              child: Text(PROCEED)),
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Text(CANCEL))
                                        ],
                                      );
                                    });
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              //Update Prices
              AnimationConfiguration.staggeredGrid(
                position: 1,
                duration: Duration(milliseconds: animationDuration),
                columnCount: 4,
                child: FadeInAnimation(
                  child: Container(
                    height: height,
                    width: width,
                    child: Card(
                      elevation: _elevation,
                      child: InkWell(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.bottomLeft,
                                color: Colors.amberAccent,
                                child: Text(UPDATE_PRICE,
                                    style: textStyle2,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Divider(
                              height: 3.0,
                              thickness: 3.0,
                              color: Colors.black,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.white,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                    'Allows to update the price for items entered in the database, however great caution should be considered by following the instractions the follow.',
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                        onTap: adminUser
                            ? () async {
                                csvFileContentList.clear();
                                csvFileModuleList.clear();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Essential Requirements'),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Needed CSV Header elements: (Exactly the same as)',
                                                  style: textStyle6,
                                                ),
                                              ),
                                              SizedBox(
                                                height: _sizedBoxHeight / 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Business Line',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('Item Code',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('Price',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                  Text('Vendor',
                                                      style: textStyle1),
                                                  SizedBox(
                                                      width: _sizedBoxHeight),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await loadCSVFromStorage(
                                                    newCurrentItemUpdate: false,
                                                    stockUpdate: false,
                                                    priceUpdate: true,
                                                    clientBalanceUpdate: false);
                                              },
                                              child: Text(PROCEED)),
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Text(CANCEL))
                                        ],
                                      );
                                    });
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              //Add update current items
              AnimationConfiguration.staggeredGrid(
                position: 1,
                duration: Duration(milliseconds: animationDuration),
                columnCount: 4,
                child: FadeInAnimation(
                  child: Container(
                    height: height,
                    width: width,
                    child: Card(
                      elevation: _elevation,
                      child: InkWell(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.bottomLeft,
                                color: Colors.amberAccent,
                                child: Text(ADD_UPDATE_ITEMS,
                                    style: textStyle2,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Divider(
                              height: 3.0,
                              thickness: 3.0,
                              color: Colors.black,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.white,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                    'Allow adding new items or updating current items with all field and requirements',
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                        onTap: adminUser
                            ? () async {
                                csvFileContentList.clear();
                                csvFileModuleList.clear();
                                _csvFileHeader =
                                    'Business Line,City,Item Code,Description,Thickness,Width,Length,Vendor,Inventory Unit,Category';
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Essential Requirements'),
                                        content: Expanded(
                                          child: Table(
                                            border: TableBorder.all(),
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child: Text('Business Line',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('City',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Item Code',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Description',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Thickness',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Width',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Length',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Vendor',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Inventory Unit',
                                                      style: textStyle1),
                                                ),
                                                TableCell(
                                                  child: Text('Category',
                                                      style: textStyle1),
                                                ),
                                              ])
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await loadCSVFromStorage(
                                                    newCurrentItemUpdate: true,
                                                    stockUpdate: false,
                                                    priceUpdate: false,
                                                    clientBalanceUpdate: false);
                                              },
                                              child: Text(PROCEED)),
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Text(CANCEL))
                                        ],
                                      );
                                    });
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              //Update Customer data
              AnimationConfiguration.staggeredGrid(
                position: 2,
                duration: Duration(milliseconds: animationDuration),
                columnCount: 4,
                child: FadeInAnimation(
                  child: Container(
                    height: height,
                    width: width,
                    child: Card(
                      elevation: _elevation,
                      child: InkWell(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, bottom: 10),
                                alignment: Alignment.bottomLeft,
                                color: Colors.amberAccent,
                                child: Text(UPDATE_CLIENT_BALANCE,
                                    style: textStyle2,
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Divider(
                              height: 3.0,
                              thickness: 3.0,
                              color: Colors.black,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                color: Colors.white,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                    'Allows to update the aging balance of each client in the system.',
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ],
                        ),
                        onTap: adminUser
                            ? () async {
                                csvFileContentList.clear();
                                csvFileModuleList.clear();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Essential Requirements'),
                                        content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Needed CSV Header elements: (Exactly the same as)',
                                                  style: textStyle6,
                                                ),
                                              ),
                                              SizedBox(
                                                height: _sizedBoxHeight / 2,
                                              ),
                                              Expanded(
                                                child: Table(
                                                  border: TableBorder.all(),
                                                  children: [
                                                    TableRow(children: [
                                                      TableCell(
                                                        child: Text(
                                                            'Invoice-to',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            'Business Partner',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            'Total Balance',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text('0-30 Days',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            '31-60 Days',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            '61-90 Days',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            '91-180 Days',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            '181-360 Days',
                                                            style: textStyle1),
                                                      ),
                                                      TableCell(
                                                        child: Text(
                                                            'Above 360 Days',
                                                            style: textStyle1),
                                                      )
                                                    ])
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await loadCSVFromStorage(
                                                    newCurrentItemUpdate: false,
                                                    stockUpdate: false,
                                                    priceUpdate: false,
                                                    clientBalanceUpdate: true);
                                              },
                                              child: Text(PROCEED)),
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                              child: Text(CANCEL))
                                        ],
                                      );
                                    });
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Picking a csv file from storage
  loadCSVFromStorage(
      {bool stockUpdate,
      bool priceUpdate,
      bool clientBalanceUpdate,
      bool newCurrentItemUpdate}) async {
    String csvFileHeaders;

    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['csv'],
      withData: true,
      type: FileType.custom,
    );

    if (result == null) {
      csvPlatformFile = null;
      print('No csv file');
    } else {
      csvPlatformFile = result.files.first;
      try {
        String csvString = new String.fromCharCodes(csvPlatformFile.bytes);
        //get the UTF8 decode as Uint8List
        var outputAsUintList = new Uint8List.fromList(csvString.codeUnits);
        //Split the Uint8List by newlines and characters to get csv file rows
        csvFileContentList = utf8.decode(outputAsUintList).split('\n');

        //Check if the column titles are in sequence
        if (csvFileContentList[0].toString().trim().hashCode !=
            _csvFileHeader.hashCode) {
          return showDialog(
              context: context,
              builder: (builder) {
                return AlertDialog(
                  title: Text('Wrong File Header'),
                  content: Text(
                      'Your csv file header does not match the requirement for this function, please change the header as mentioned before updating.'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(OK_BUTTON))
                  ],
                );
              });
        }
        //Check if csv file has any content
        if (csvFileContentList.length == 0 ||
            csvFileContentList[1].length == 0) {
          return showDialog(
              context: context,
              builder: (builder) {
                return AlertDialog(
                  title: Text('No Content'),
                  content: Text('Your csv file does not have any content.'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(OK_BUTTON))
                  ],
                );
              });
        }
        List csvList = [];
        List<String> headerRow = csvFileContentList[0].toString().split(',');
        //Add the headers
        csvFileModuleList.add(headerRow);
        //remove headers so it won't be mapped
        csvFileContentList.removeAt(0);
        //Remove duplicates
        csvList = csvFileContentList.toSet().toList();

        //Array class module
        csvList.forEach((csvRow) {
          if (csvRow != null && csvRow.toString().trim().isNotEmpty) {
            List<String> shortRow = [];
            Map<String, dynamic> mappedList = new Map();
            List<String> splitedRow = csvRow.toString().split(',');

            for (var i = 0; i < splitedRow.length; i++) {
              shortRow.add(splitedRow[i]);

              mappedList.addAll({headerRow[i]: splitedRow[i]});
            }
            csvMapList.add(mappedList);
            csvFileModuleList.add(shortRow);
          }
        });
        if (csvFileModuleList != null || csvFileModuleList.isNotEmpty) {
          if (stockUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) {
                  return LoadCsvStockData(
                    file: csvFileModuleList,
                    mapList: csvMapList,
                  );
                },
              ),
            );
          }
          if (priceUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) {
                  return LoadCsvPriceData(
                    file: csvFileModuleList,
                    mapList: csvMapList,
                  );
                },
              ),
            );
          }
          if (clientBalanceUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) {
                  return LoadCsvStatementData(
                    file: csvFileModuleList,
                    mapList: csvMapList,
                  );
                },
              ),
            );
          }
          if (newCurrentItemUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) {
                  return NewCurrentItemUpdate(
                    file: csvFileModuleList,
                    mapList: csvMapList,
                  );
                },
              ),
            );
          }
        }
      } catch (e) {
        String errorTitle, errorContent;
        if (e.toString().contains('RangeError')) {
          errorTitle = 'Range Error (Index)';
          errorContent =
              'There seems to be a comma in one of the cells, please remove then upload';
        } else {
          errorTitle = 'Unknown error';
          errorContent = 'Please check with admin: $e';
        }

        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  title: Text(errorTitle),
                  content: Text(errorContent),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(OK_BUTTON))
                  ],
                ));
        return e.toString();
      }
    }
  }
}
