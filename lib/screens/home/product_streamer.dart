import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_type.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class ProductStreamer extends StatefulWidget {
  final List<dynamic> roles;
  ProductStreamer({this.roles});
  @override
  _ProductStreamerState createState() => _ProductStreamerState();
}

class _ProductStreamerState extends State<ProductStreamer>
    with SingleTickerProviderStateMixin {
  PaintMaterial paintProducts;
  WoodProduct woodSolidProducts;
  Accessories accessoriesProducts;
  Lights lightProducts;
  int currentTabIndex = 1;
  bool viewProducts;
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
  double distanceBetweenInkWells = 10.0;
  TabController _tabController;
  DatabaseService db = DatabaseService();
  double inkWellHeight = 120.0;
  var categories = [];
  void initState() {
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
    roles = widget.roles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(PRODUCTS),
        elevation: 0.0,
        backgroundColor: Colors.amber[300],
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              color: Colors.orange),
          onTap: (index) {
            currentTabIndex = index;
          },
          tabs: [
            new Tab(
              text: TAB_COATINGS_AND_ADHESIVES,
            ),
            new Tab(
              text: TAB_WOOD_TEXT,
            ),
            new Tab(text: TAB_SS_TEXT),
            new Tab(text: TAB_ACCESSORIES_TEXT),
            new Tab(text: TAB_INDUSTRIAL_TEXT)
          ],
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: TabBarView(
        children: [
          _buildPaintWidget(),
          _buildWoodWiget(),
          _buildSolidSurfaceWiget(),
          _buildAccessoriesWiget(),
          _buildIndustrialWidget(),
        ],
        controller: _tabController,
      ),
    );
  }

  _getProductCategories(String brandName) async {
    categories = [];
    var result = await db.brandCollection
        .where('brandName', isEqualTo: brandName)
        .get()
        .then(
          (value) => value.docs.map((e) {
            categories = e.data()['category'];
            return e.data()['category'];
          }).toList(),
        );

    return result;
  }

  Widget _buildPaintWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Sayerlack Inkwell
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(SAYERLACK_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_PAINT_TEXT,
                            brandName: SAYERLACK_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/sayerlack_logo.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //EVI Inkwell
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(EVI_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_PAINT_TEXT,
                            brandName: EVI_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/evi_logo.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Unicol Inkwell
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(UNICOL_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_PAINT_TEXT,
                            brandName: UNICOL_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/unicol_logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Larius
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(LARIUS_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: MACHINES,
                            brandName: LARIUS_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/larius-logo.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWoodWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Halspan Inkwell
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(HALSPAN_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_WOOD_TEXT,
                            brandName: HALSPAN_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/halspan.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //FINSA
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(FINSA_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_WOOD_TEXT,
                            brandName: FINSA_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/finsa.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //SONAE
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(SONAE_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_WOOD_TEXT,
                            brandName: SONAE_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/sonae.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Linex
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(LINEX_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_WOOD_TEXT,
                            brandName: LINEX_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/linex-logo.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Formica
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(FORMICA_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: TAB_WOOD_TEXT,
                            brandName: FORMICA_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/formica.jpg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolidSurfaceWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Corian
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(CORIAN_BRAND);
                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: SOLID_SURFACE,
                            brandName: CORIAN_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/corian.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Monteli
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(MONTELLI_BRAND);
                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: SOLID_SURFACE,
                            brandName: MONTELLI_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/montelli.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessoriesWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Salice
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(SALICE_BRAND);
                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: ACCESSORIES,
                            brandName: SALICE_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/salice.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Indaux
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(INDAUX_BRAND);
                    if (result != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: ACCESSORIES,
                            brandName: INDAUX_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/indaux.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndustrialWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Extra Form
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(CORIAN_BRAND);
                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: SOLID_SURFACE,
                            brandName: CORIAN_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/corian.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Variant
            Container(
              height: inkWellHeight,
              child: InkWell(
                onTap: () async {
                  if (widget.roles.isNotEmpty) {
                    var result = await _getProductCategories(MONTELLI_BRAND);
                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductType(
                            productType: SOLID_SURFACE,
                            brandName: MONTELLI_BRAND,
                            user: user,
                            roles: roles,
                            category: categories,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width / 4,
                  height: inkWellHeight,
                  child: Image.asset('images/brands/montelli.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
          ],
        ),
      ),
    );
  }
}
