import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_form.dart';
import 'package:unitrade_web_v2/products/product_list.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class ProductsGrid extends StatefulWidget {
  final String productType;
  final String brandName;
  final String categoryType;
  final Function callBackUpdate;
  final UserData user;
  final List<dynamic> roles;
  ProductsGrid(
      {this.productType,
      this.brandName,
      this.categoryType,
      this.callBackUpdate,
      this.user,
      this.roles});
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductsGrid> {
  List<String> paintProduct = [];
  List<String> woodProduct = [];

  var result;
  String productColorMain = 'clear';
  @override
  void initState() {
    super.initState();
  }

  void productColorCallback(String productColor) {
    setState(() {
      productColorMain = productColor;
    });
  }

  //function to add new products
  void _addNewProduct() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductForm(
                  roles: widget.roles,
                )));
  }

  //return the build widget for all products
  Widget productBuild() {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(PRODUCTS),
          backgroundColor: Colors.amberAccent,
          elevation: 1.0,
          actions: <Widget>[
            widget.roles.contains('isAdmin')
                ? FlatButton.icon(
                    onPressed: () => _addNewProduct(),
                    icon: new IconTheme(
                        data: new IconThemeData(color: Colors.white),
                        child: Icon(Icons.menu)),
                    label: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
        body: Container(
          child: ProductList(
            roles: widget.roles,
            productBrand: widget.brandName,
            productType: widget.productType,
            productCategory: widget.categoryType,
            productColorCallback: productColorCallback,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.categoryType) {
      case PU_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType,
                  productColor: productColorMain),
              child: productBuild());
        }
        break;
      case NC_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType,
                  productColor: productColorMain),
              child: productBuild());
        }
        break;
      case STAIN:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType),
              child: productBuild());
        }
        break;
      case AC_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType,
                  productColor: productColorMain),
              child: productBuild());
        }
        break;
      case THINNER:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType,
              ),
              child: productBuild());
        }
        break;
      case EXT_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
            value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType,
                productColor: productColorMain),
            child: productBuild(),
          );
        }
        break;
      case SPECIAL_PRODUCT:
        {
          return StreamProvider<List<PaintMaterial>>.value(
            value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case GLUE_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
            value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case SPRAY_MACHINES:
        {
          return StreamProvider<List<Machines>>.value(
            value: DatabaseService().machineProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case SPARE_PARTS:
        {
          return StreamProvider<List<Machines>>.value(
            value: DatabaseService().machineProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case MDF_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().woodProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case FIRE_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().woodProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case HPL_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().woodProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case CHIP_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().woodProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case COR_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().solidSurfaceProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case MON_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().solidSurfaceProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case COR_SINKS:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().solidSurfaceProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case SS_ADHESIVE_BUTTON:
        {
          return StreamProvider<List<WoodProduct>>.value(
            value: DatabaseService().solidSurfaceProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case HINGES:
        {
          return StreamProvider<List<Accessories>>.value(
            value: DatabaseService().accessoriesProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case RUNNERS:
        {
          return StreamProvider<List<Accessories>>.value(
            value: DatabaseService().accessoriesProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case FLAP:
        {
          return StreamProvider<List<Accessories>>.value(
            value: DatabaseService().accessoriesProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;

      default:
        {
          return Container(
            child: Center(
                child: Text(
                    'An unexpected Error occured in productGrid occurred')),
          );
        }
    }
  }
}
