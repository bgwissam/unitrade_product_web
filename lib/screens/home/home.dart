import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_form.dart';
import 'package:unitrade_web_v2/screens/home/product_streamer.dart';
import 'package:unitrade_web_v2/screens/home/sign_out.dart';
import 'package:unitrade_web_v2/services/auth.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
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
  String addProductButton = 'Add New Product';
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
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
                          width: 15.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
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
                          width: 15.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
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
