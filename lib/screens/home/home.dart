import 'dart:html';
import 'dart:typed_data';
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
  File csvFile;
  String csvFileName;
  String csvFilePath;
  String errorText;
  Uint8List uploadedFile;
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterUser()));
                            },
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
                            onPressed: () async {
                              loadCSVFromStorage();
                            },
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
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) async {
      //Read file content as dataUrl
      final files = uploadInput.files;
      if (files.length == 1) {
        csvFile = files[0];
        FileReader reader = FileReader();
        print('The files: ${csvFile.size}');
        reader.onLoadEnd.listen((event) {
          setState(() {
            uploadedFile = reader.result;
          });
        });
        reader.onError.listen((error) {
          setState(() {
            errorText = 'The following error occured: $error';
          });
        });
        reader.readAsArrayBuffer(csvFile);
        csvFileName = csvFile.name;
        csvFilePath = csvFile.relativePath;

        print('Name: $csvFileName Path: $csvFilePath');
        print('Uploaded file: $uploadedFile');
      }
    });

    if (csvFilePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) {
            return LoadCsvDataScreen(
              path: csvFilePath,
            );
          },
        ),
      );
    } else {
      print('The file picker returned null');
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
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(ALERT_NO),
              ),
              new FlatButton(
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
