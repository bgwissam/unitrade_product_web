import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/brands/brand_grid.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_form.dart';
import 'package:unitrade_web_v2/screens/home/product_streamer.dart';
import 'package:unitrade_web_v2/screens/home/register.dart';
import 'package:unitrade_web_v2/screens/home/sign_out.dart';
import 'package:unitrade_web_v2/services/auth.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/csv_file_converter.dart';
import 'package:unitrade_web_v2/shared/string.dart';
import 'package:unitrade_web_v2/shared/functions.dart';
import 'package:unitrade_web_v2/brands/brand_form.dart';

class Home extends StatefulWidget {
  final String userId;
  Home({this.userId});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  PaintMaterial paintProducts;
  WoodProduct woodSolidProducts;
  Accessories accessoriesProducts;
  Lights lightProducts;
  int currentTabIndex;
  bool viewProducts;
  double distanceBetweenInkWells = 10.0;
  //User details
  List<dynamic> roles = [];
  String firstName;
  String lastName;
  String emailAddress;
  String company;
  String phoneNumber;
  String countryOfResidence;
  String cityOfResidence;
  UserData user;
  bool adminUser = false;
  double height = 75;
  double width = 300;
  String addProductButton = 'Add New Product';
  PlatformFile csvPlatformFile;
  File csvFile;
  String csvFileName;
  String csvFilePath;
  String errorText;
  Uint8List uploadedFile;
  List csvFileContentList = [];
  List csvFileModuleList = [];
  List<Map<String, dynamic>> csvMapList = [];
  void initState() {
    super.initState();
    _getUserData();
    viewProducts = false;
  }

  AuthService _auth = new AuthService();

  //Get user details
  //get the first name of the user
  Future _getUserData() async {
    DatabaseService databaseService = DatabaseService(uid: widget.userId);
    await databaseService.unitradeCollection
        .doc(widget.userId)
        .get()
        .then((value) {
      firstName = value.data()['firstName'];
      lastName = value.data()['lastName'];
      company = value.data()['company'];
      phoneNumber = value.data()['phoneNumber'];
      countryOfResidence = value.data()['countryOfResidence'];
      cityOfResidence = value.data()['cityOfResidence'];
      emailAddress = value.data()['emailAddress'];
      roles = value.data()['roles'];

      if (firstName != null) {
        firstName = firstName.capitalize();
      }
      if (lastName != null) {
        lastName = lastName.capitalize();
      }
      if (company != null) {
        company = company.capitalize();
      }
      setState(() {
        roles.contains('isAdmin') ? adminUser = true : adminUser = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HOME_PAGE),
        elevation: 5.0,
        backgroundColor: Colors.amberAccent,
        actions: [
          ButtonTheme(
            minWidth: 150.0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 25.0, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: TextButton(
                    onPressed: () async {
                      onBackPressed();
                    },
                    child: Center(
                        child: Text(
                      SIGN_OUT,
                      style: buttonStyle2,
                    ))),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 100.0, horizontal: 5.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //viewing current products
                        Container(
                          height: height,
                          width: width,
                          child: RaisedButton(
                            child: Text(
                              PRODUCTS,
                              style: textStyle2,
                            ),
                            color: Colors.deepOrange[500],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: Colors.black)),
                            textColor: Colors.black,
                            padding: EdgeInsets.all(15.0),
                            disabledColor: Colors.grey[300],
                            disabledElevation: 0.0,
                            elevation: 5.0,
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductStreamer(roles: roles)));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        //Adding a product
                        Container(
                          height: height,
                          width: width,
                          child: RaisedButton(
                            child: Text(
                              ADD_PRODUCT,
                              style: textStyle2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: Colors.black)),
                            textColor: Colors.black,
                            color: Colors.deepOrange[500],
                            padding: EdgeInsets.all(15.0),
                            disabledColor: Colors.grey[600],
                            disabledElevation: 0.0,
                            elevation: 5.0,
                            onPressed: adminUser
                                ? () async {
                                    addProduct();
                                  }
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        //Adding a brand
                        Container(
                          height: height,
                          width: width,
                          child: RaisedButton(
                            child: Text(
                              ADD_BRAND,
                              style: textStyle2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: Colors.black)),
                            textColor: Colors.black,
                            color: Colors.deepOrange[500],
                            padding: EdgeInsets.all(15.0),
                            disabledColor: Colors.grey[600],
                            disabledElevation: 0.0,
                            elevation: 5.0,
                            onPressed: roles.contains('isSuperAdmin')
                                ? () async {
                                    addBrand();
                                  }
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        //Viewing current brands
                        Container(
                          height: height,
                          width: width,
                          child: ElevatedButton(
                            child: Text(
                              VIEW_BRANDS,
                              style: textStyle2,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: Colors.black),
                              ),
                              primary: Colors.deepOrange[500],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BrandGrid(
                                            roles: roles,
                                          )));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        //Register new users
                        Container(
                          height: height,
                          width: width,
                          child: ElevatedButton(
                            child: Text(
                              REGISTER_USER,
                              style: textStyle2,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: Colors.black),
                              ),
                              primary: Colors.deepOrange[500],
                            ),
                            onPressed: adminUser
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterUser()));
                                  }
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        //Update stock levels
                        Container(
                          height: height,
                          width: width,
                          child: ElevatedButton(
                            child: Text(
                              UPDATE_STOCK,
                              style: textStyle2,
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(color: Colors.black),
                              ),
                              primary: Colors.deepOrange[500],
                            ),
                            onPressed: adminUser
                                ? () async {
                                    csvFileContentList.clear();
                                    csvFileModuleList.clear();
                                    await loadCSVFromStorage();
                                  }
                                : null,
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Picking a csv file from storage
  loadCSVFromStorage() async {
    String csvFileHeaders = 'Item Code,Description,Inventory on Hand,City,' +
        'Inventory Unit,Length,Width,Thickness,Vendor,Business Unit,Inventory on Hand in SU,Inventory ' +
        'Transfers & SO,Inventory in Transit,On Hand & In Transit';

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
            csvFileHeaders.hashCode) {
          print('Sorry, you don\'t have the right format');
        }
        //Check if csv file has any content
        if (csvFileContentList.length == 0 ||
            csvFileContentList[1].length == 0) {
          print('The selected file has no content');
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) {
                return LoadCsvDataScreen(
                  file: csvFileModuleList,
                  mapList: csvMapList,
                );
              },
            ),
          );
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

  //Dailog box for exiting the website
  Future onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(EXIT_APP_TITLE),
            content: Text(EXIT_APP_CONTENT),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(ALERT_NO),
              ),
              TextButton(
                onPressed: () {
                  if (this.mounted) {
                    _auth.signOut();

                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new SignedOut()));
                  }
                },
                child: Text(ALERT_YES),
              ),
            ],
          );
        });
  }

  //Add new products
  addProduct() async {
    //Will send the user to a new class where they can add a new product
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductForm(roles: roles),
      ),
    );
  }

  //Add new Brand
  addBrand() async {
    //Will send the user to a new class where they can add a new brand
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BrandForm(roles: roles)));
  }
}
