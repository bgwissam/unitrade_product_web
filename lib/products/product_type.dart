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
  final List<dynamic> category;
  ProductType(
      {this.productType, this.brandName, this.user, this.roles, this.category});
  @override
  _ProductTypeState createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {
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
    if (widget.productType != null && widget.category.isNotEmpty) {
      return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
            child: _buildPaintListType()),
      );
    } else {
      return Container(
        child: Text('An Error occured, check with Admin'),
      );
    }
  }

  Widget _buildPaintListType() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: widget.category.length,
          itemBuilder: (context, index) {
            return Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: widget.productType,
                              categoryType: widget.category[index].toString(),
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
                    widget.category[index],
                    style: inkWellText,
                  )),
                ),
              ),
            );
          }),
    );
  }
}
