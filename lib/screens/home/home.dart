import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:date_util/date_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/brands/brand_grid.dart';
import 'package:unitrade_web_v2/locations/googl_map_locations.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_form.dart';
import 'package:unitrade_web_v2/sales_pipeline/pipeline_grid.dart';
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
  List<UserData> normalUsers;
  bool adminUser = false;
  double height = 20;
  double width = 10;
  var _elevation = 2.0;
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
    _getNormalUser();
    currentYear = DateTime(now.year);
    viewProducts = false;
  }

  AuthService _auth = new AuthService();
  DatabaseService db = new DatabaseService();
  List<dynamic> salesTeamId = [];
  String selectedSalesId;
  int selectedIndex;
  int monthIndex = 0;
  int daysInMonth = 0;
  String selectedYear = '2021';
  var _sizedBoxHeight = 10.0;
  var dateUtility = DateUtil();
  DateTime now = DateTime.now();
  DateTime currentYear;
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
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

  //Get Normal Users to the sales pipeline
  Future _getNormalUser() async {
    var result = await db.unitradeCollection
        .where('roles', arrayContains: 'isNormalUser')
        .get()
        .then((value) {
      return value.docs
          .map(
            (e) => UserData(
                uid: e.id,
                firstName: e.data()['firstName'],
                lastName: e.data()['lastName']),
          )
          .toList();
    });
    normalUsers = result;
    return result;
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 200,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  child: Text(
                    'The following page presents the options under which you can view, add, and change the database concerning the Uni Products apps for Unitrade Company.',
                    style: textStyle4,
                  ),
                ),
                Divider(
                  thickness: 3.0,
                  height: 10.0,
                  color: Colors.black,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 210,
                  child: GridView.count(
                      primary: false,
                      crossAxisCount: 3,
                      childAspectRatio: 0.85,
                      mainAxisSpacing: 50,
                      crossAxisSpacing: 110,
                      shrinkWrap: true,
                      children: [
                        //viewing current products
                        Container(
                          height: height,
                          width: width,
                          child: Card(
                            color: Colors.grey[300],
                            elevation: _elevation,
                            child: InkWell(
                              child: Column(children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.bottomLeft,
                                    color: Colors.amberAccent,
                                    child: Text(PRODUCTS,
                                        style: textStyle2,
                                        textAlign: TextAlign.start),
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
                                        'Products section will present all the products available at our company.',
                                        textAlign: TextAlign.start),
                                  ),
                                ),
                              ]),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductStreamer(roles: roles)));
                              },
                            ),
                          ),
                        ),

                        //Adding a product
                        Container(
                          height: height,
                          width: width,
                          child: Card(
                            elevation: _elevation,
                            child: InkWell(
                              onTap: adminUser
                                  ? () async {
                                      addProduct();
                                    }
                                  : null,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      alignment: Alignment.bottomLeft,
                                      color: Colors.amberAccent,
                                      child: Text(ADD_PRODUCT,
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
                                          'This section will allow you to add in a new product for any category and brand you specify.',
                                          textAlign: TextAlign.start),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Adding a brand
                        Container(
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
                                      child: Text(ADD_BRAND,
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
                                          'This section will allow you to add in a new brand, and specify the categories under which the brand will occupy',
                                          textAlign: TextAlign.start),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: roles.contains('isSuperAdmin')
                                  ? () async {
                                      addBrand();
                                    }
                                  : null,
                            ),
                          ),
                        ),

                        //Viewing current brands
                        Container(
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
                                      child: Text(VIEW_BRANDS,
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
                                          'From here you can view the brands as well as edit them',
                                          textAlign: TextAlign.start),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BrandGrid(
                                              roles: roles,
                                            )));
                              },
                            ),
                          ),
                        ),

                        //Register new users
                        Container(
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
                                      child: Text(REGISTER_USER,
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
                                          'Register a new user by defining the roles features in order to access the web page and the mobile app.',
                                          textAlign: TextAlign.start),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: adminUser
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
                        ),

                        //Update stock levels
                        Container(
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
                                      await loadCSVFromStorage();
                                    }
                                  : null,
                            ),
                          ),
                        ),

                        //Sales pipline view
                        Container(
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
                                      child: Text(SALES_PIPELINE,
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
                                          'Sales pipeline monitures the activity of the sales team on a daily basis',
                                          textAlign: TextAlign.start),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: adminUser
                                  ? () {
                                      //will open a dialog to allow selecting a sales person
                                      //after which you can view their sales activity
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                    title: Text(
                                                        SELECT_SALES_PERSON),
                                                    content: Container(
                                                      height: 320,
                                                      width: 800,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                                'Please select a sales person, month, and year from the folloing list in order to view their pipeline data'),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Container(
                                                            height: 120,
                                                            width: 700,
                                                            decoration: BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25)),
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        normalUsers
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                                index) =>
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Container(
                                                                                color: selectedIndex != null && selectedIndex == index ? Colors.red : Colors.white,
                                                                                child: InkWell(
                                                                                  child: Text('${normalUsers[index].firstName} ${normalUsers[index].lastName}'),
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      selectedIndex = index;
                                                                                      selectedSalesId = normalUsers[index].uid;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            )),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                _sizedBoxHeight,
                                                          ),
                                                          //Select the month and year you want to view
                                                          Container(
                                                            height: 150.0,
                                                            width: 750.0,
                                                            child: Column(
                                                              children: [
                                                                //Select year
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border
                                                                          .all(),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  height: 60.0,
                                                                  width: 600.0,
                                                                  child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              60.0,
                                                                          child:
                                                                              Text(
                                                                            'Year: ',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                textStyle1,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.0,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              60.0,
                                                                          child:
                                                                              TextFormField(
                                                                            initialValue:
                                                                                currentYear.toString().split('-')[0],
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            maxLength:
                                                                                4,
                                                                            onChanged:
                                                                                (val) {
                                                                              if (val != null)
                                                                                selectedYear = val;
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      _sizedBoxHeight,
                                                                ),
                                                                //Select month of year
                                                                Container(
                                                                  height: 60.0,
                                                                  width: 600.0,
                                                                  child: Center(
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: months.length,
                                                                        itemBuilder: (context, index) {
                                                                          return Card(
                                                                            color: monthIndex == index
                                                                                ? Colors.red
                                                                                : Colors.grey,
                                                                            elevation: monthIndex == index
                                                                                ? 0.0
                                                                                : 3.0,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  monthIndex = index;
                                                                                  selectedYear != null ? daysInMonth = dateUtility.daysInMonth(index + 1, int.parse(selectedYear)) : daysInMonth = dateUtility.daysInMonth(index + 1, 2021);
                                                                                });
                                                                              },
                                                                              child: Center(
                                                                                child: Text(
                                                                                  months[index],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            selectedIndex !=
                                                                        null &&
                                                                    monthIndex !=
                                                                        0
                                                                ? () async {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (builder) =>
                                                                                PipelineGrid(
                                                                          salesId:
                                                                              selectedSalesId,
                                                                          selectedMonth:
                                                                              monthIndex + 1,
                                                                          selectedYear:
                                                                              selectedYear,
                                                                          daysInMonth:
                                                                              daysInMonth,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                : null,
                                                        child: Text(NEXT_PAGE),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(CLOSE),
                                                      ),
                                                    ]);
                                              },
                                            );
                                          });
                                    }
                                  : null,
                            ),
                          ),
                        ),

                        //View location on google map
                        Container(
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
                                      child: Text(CLIENT_MAP,
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
                                          'The map will allow to view all the clients assigned to UniTrade by the sales team',
                                          textAlign: TextAlign.start),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: adminUser
                                  ? () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GoogleMapLocation()));
                                    }
                                  : null,
                            ),
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
