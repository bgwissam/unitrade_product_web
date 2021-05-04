import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_grid.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class ProductType extends StatefulWidget {
  final String productType;
  final String brandName;
  final UserData user;
  final List<dynamic> roles;
  ProductType({this.productType, this.brandName, this.user, this.roles});
  @override
  _ProductTypeState createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {
  void initState() {
    super.initState();
  }

  double inkWellWidth = 50.0;
  double inkWellHeight = 50.0;
  double sizedBoxDistance = 25.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PRODUCT_TYPE),
        backgroundColor: Colors.amberAccent[400],
      ),
      body: _buildProductType(),
    );
  }

  Widget _buildProductType() {
    if (widget.productType == COATINGS)
      return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
            child: _buildPaintListType()),
      );
    else if (widget.productType == ADHESIVE) {
      return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
            child: _buildAdhesiveListType()),
      );
    } else if (widget.productType == WOOD)
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
          child: _buildWoodListType(),
        ),
      );
    else if (widget.productType == SOLID_SURFACE)
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
          child: _buildSolidSurafceListType(),
        ),
      );
    else if (widget.productType == ACCESSORIES)
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
          child: _buildAccessoriesListType(),
        ),
      );
    else if(widget.productType == MACHINES) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
          child: _buildSprayMachineUnit(),
        ),
      );
    }
    else {
      return Container(
        child: Text('An Error occured, check with Admin'),
      );
    }
  }

  Widget _buildPaintListType() {
    return GridView.count(
      mainAxisSpacing: 40.0,
      crossAxisSpacing: 40.0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 5,
      children: [
        //PU Paint
        widget.productType == COATINGS
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_PAINT_TEXT,
                                categoryType: PU_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      PU_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //NC Paint
        widget.productType == COATINGS
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_PAINT_TEXT,
                                categoryType: NC_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      NC_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //Stain
        widget.productType == COATINGS
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_PAINT_TEXT,
                                brandName: widget.brandName,
                                categoryType: STAIN,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      STAIN,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //Thinner
        widget.productType == COATINGS
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_PAINT_TEXT,
                                brandName: widget.brandName,
                                categoryType: THINNER,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      THINNER,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //Exterior Paint
        widget.productType == 'COATING'
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_PAINT_TEXT,
                                brandName: widget.brandName,
                                categoryType: EXT_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      EXT_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //Acrylic Paint
        widget.productType == COATINGS
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_PAINT_TEXT,
                                brandName: widget.brandName,
                                categoryType: AC_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      AC_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //Special Paint
        widget.productType == COATINGS
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_PAINT_TEXT,
                                brandName: widget.brandName,
                                categoryType: SPECIAL_PRODUCT,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      SPECIAL_PRODUCT,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildAdhesiveListType() {
    return GridView.count(
      mainAxisSpacing: 40.0,
      crossAxisSpacing: 40.0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 5,
      children: [
        //Glue
        widget.productType == ADHESIVE
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_PAINT_TEXT,
                                brandName: widget.brandName,
                                categoryType: GLUE_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      GLUE_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildWoodListType() {
    return GridView.count(
      mainAxisSpacing: 40.0,
      crossAxisSpacing: 40.0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 5,
      children: [
        //MDF
        widget.productType == WOOD
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_WOOD_TEXT,
                                categoryType: MDF_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      MDF_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
        //Firerated products
        widget.productType == WOOD
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_WOOD_TEXT,
                                categoryType: FIRE_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      FIRE_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
        //Formica products
        widget.productType == WOOD
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_WOOD_TEXT,
                                categoryType: HPL_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      HPL_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
        //Chipboard
        widget.productType == WOOD
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_WOOD_TEXT,
                                categoryType: CHIP_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      CHIP_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildSolidSurafceListType() {
    return GridView.count(
      mainAxisSpacing: 40.0,
      crossAxisSpacing: 40.0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 5,
      children: [
        //Corian
        widget.productType == SOLID_SURFACE
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_SS_TEXT,
                                categoryType: COR_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      COR_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
        //Monteli
        widget.productType == SOLID_SURFACE
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_SS_TEXT,
                                categoryType: MON_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      MON_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
        //Sinks
        widget.productType == SOLID_SURFACE
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_SS_TEXT,
                                categoryType: COR_SINKS,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      COR_SINKS,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),

        //Adhesives
        widget.productType == SOLID_SURFACE
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_SS_TEXT,
                                categoryType: SS_ADHESIVE_BUTTON,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    child: Center(
                        child: Text(
                      SS_ADHESIVE_BUTTON,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildAccessoriesListType() {
    return GridView.count(
      mainAxisSpacing: 40.0,
      crossAxisSpacing: 40.0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 5,
      children: [
        //Hinges
        widget.productType == ACCESSORIES
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_ACCESSORIES_TEXT,
                                categoryType: HINGES,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Center(
                        child: Text(
                      HINGES,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
            //Runners
            widget.productType == ACCESSORIES
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_ACCESSORIES_TEXT,
                                categoryType: RUNNERS,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Center(
                        child: Text(
                      RUNNERS,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
            //Flap Mechanism
            widget.productType == ACCESSORIES
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                brandName: widget.brandName,
                                productType: TAB_ACCESSORIES_TEXT,
                                categoryType: FLAP,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Center(
                        child: Text(
                      FLAP,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),



      ],
    );
  }

  Widget _buildSprayMachineUnit() {
    print(widget.productType);
    return GridView.count(
      mainAxisSpacing: 40.0,
      crossAxisSpacing: 40.0,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 5,
      children: [
        //Spray Machine
        widget.productType == MACHINES
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_MACHINE_TEXT,
                                brandName: widget.brandName,
                                categoryType: SPRAY_MACHINES,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      SPRAY_MACHINES,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
            //Spare Parts
             widget.productType == MACHINES
            ? Container(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductsGrid(
                                user: widget.user,
                                roles: widget.roles,
                                productType: TAB_MACHINE_TEXT,
                                brandName: widget.brandName,
                                categoryType: SPARE_PARTS,
                              ))),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(25.0)),
                    width: inkWellWidth,
                    height: inkWellHeight,
                    child: Center(
                        child: Text(
                      SPARE_PARTS,
                      style: inkWellText,
                    )),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

}
