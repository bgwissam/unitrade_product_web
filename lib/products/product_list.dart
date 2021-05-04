import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_tile.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class ProductList extends StatefulWidget {
  final List<dynamic> roles;
  final String productBrand;
  final String productType;
  final String productCategory;
  final Function productColorCallback;
  ProductList(
      {this.roles,
      this.productBrand,
      this.productType,
      this.productCategory,
      this.productColorCallback});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var products;
  bool clearButton = false;
  bool pigmentedButton = true;
  String productColor;
  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height / 4;
    final double itemWidth = size.width / 10;
    switch (widget.productType) {
      case TAB_PAINT_TEXT:
        products = Provider.of<List<PaintMaterial>>(context) ?? [];
        break;
      case TAB_SS_TEXT:
        products = Provider.of<List<WoodProduct>>(context) ?? [];
        break;
      case TAB_WOOD_TEXT:
        products = Provider.of<List<WoodProduct>>(context) ?? [];
        break;
      case TAB_LIGHT_TEXT:
        products = Provider.of<List<Lights>>(context) ?? [];
        break;
      case TAB_ACCESSORIES_TEXT:
        products = Provider.of<List<Accessories>>(context) ?? [];
        break;
      case TAB_MACHINE_TEXT:
        products = Provider.of<List<Machines>>(context) ?? [];
        break;
    }

    final user = Provider.of<UserData>(context) ?? [];
    if (products.isNotEmpty) {
      return Column(
        children: [
          if (widget.productCategory == NC_BUTTON ||
              widget.productCategory == PU_BUTTON ||
              widget.productCategory == AC_BUTTON)
            Container(
              height: 50.0,
              child: _buildClearAndPigmentedButton(),
            ),
          Container(
            height: MediaQuery.of(context).size.height - 150.0,
            child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: (itemWidth / itemHeight),
                padding: EdgeInsets.all(10.0),
                children: List.generate(products.length, (index) {
                  switch (widget.productType) {
                    case TAB_PAINT_TEXT:
                      return ProductTile(
                        roles: widget.roles,
                        product: products[index],
                        productBrand: widget.productBrand,
                        productType: widget.productType,
                        user: user,
                      );
                      break;
                    case TAB_WOOD_TEXT:
                      return ProductTile(
                        woodProduct: products[index],
                        productBrand: widget.productBrand,
                        productType: widget.productType,
                        user: user,
                        roles: widget.roles,
                      );
                      break;
                    case TAB_SS_TEXT:
                      return ProductTile(
                        woodProduct: products[index],
                        productBrand: widget.productBrand,
                        productType: widget.productType,
                        user: user,
                        roles: widget.roles,
                      );
                      break;
                    case TAB_LIGHT_TEXT:
                      return ProductTile(
                        lightProduct: products[index],
                        productBrand: widget.productBrand,
                        productType: widget.productType,
                        user: user,
                        roles: widget.roles,
                      );
                      break;
                    case TAB_ACCESSORIES_TEXT:
                      return ProductTile(
                        accessoriesProduct: products[index],
                        productBrand: widget.productBrand,
                        productType: widget.productType,
                        user: user,
                        roles: widget.roles,
                      );
                      break;
                    case TAB_MACHINE_TEXT:
                      return ProductTile(
                        machineProduct: products[index],
                        productBrand: widget.productBrand,
                        productType: widget.productType,
                        user: user,
                        roles: widget.roles,
                      );
                    default:
                      {
                        return Container(
                          child: Center(
                            child: Text('An unexpected error occured'),
                          ),
                        );
                      }
                  }
                })),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.productCategory == NC_BUTTON ||
            widget.productCategory == PU_BUTTON ||
            widget.productCategory == AC_BUTTON)
          Container(
            height: 50.0,
            child: _buildClearAndPigmentedButton(),
          ),
        Container(
          child: Center(child: Text(EMPTY_PRODUCT_LIST)),
        ),
      ],
    );
  }

  //builds the button to seperate between clear and pigmented
  Widget _buildClearAndPigmentedButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: RaisedButton(
              color: Colors.amber,
              child: Text(CLEAR_BUTTON),
              elevation: clearButton ? 5.0 : 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              onPressed: clearButton
                  ? () {
                      clearButton = false;
                      pigmentedButton = true;
                      widget.productColorCallback('clear');
                    }
                  : null,
            ),
          ),
          Container(
            child: RaisedButton(
              child: Text(PIGMENTED_BUTTON),
              color: Colors.blue[300],
              elevation: pigmentedButton ? 5.0 : 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              onPressed: pigmentedButton
                  ? () {
                      clearButton = true;
                      pigmentedButton = false;
                      widget.productColorCallback('pigmented');
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
