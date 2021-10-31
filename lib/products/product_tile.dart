import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/products/product_form.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/loading.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class ProductTile extends StatefulWidget {
  final PaintMaterial product;
  final WoodProduct woodProduct;
  final Lights lightProduct;
  final Accessories accessoriesProduct;
  final Machines machineProduct;
  final UserData user;
  final String productBrand;
  final String productType;
  final String productName;
  final String productPack;
  final String length;
  final String width;
  final String thickness;
  final String productColor;
  final List<String> productImage;
  final List<String> cartList;
  final Function callback;
  final Function writeToFile;
  final Function callbackCart;
  final List<dynamic> roles;
  ProductTile(
      {this.product,
      this.woodProduct,
      this.lightProduct,
      this.accessoriesProduct,
      this.machineProduct,
      this.user,
      this.productBrand,
      this.productType,
      this.productName,
      this.productPack,
      this.length,
      this.width,
      this.thickness,
      this.productColor,
      this.productImage,
      this.callback,
      this.writeToFile,
      this.cartList,
      this.callbackCart,
      this.roles});
  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool isAdmin = false;
  bool isPriceAdmin = false;
  String userId;
  String imageUrl;
  List<String> paintList = [];
  List<String> woodList = [];
  var stockChildren = <Widget>[];
  String placeHolderImage = 'images/placeholder.png';
  @override
  void initState() {
    super.initState();
  }

  //check if the current user is an Admin or not
  Future getCurrentUser() async {
    userId = widget.user.uid;
    DatabaseService databaseService = DatabaseService(uid: widget.user.uid);
    var result = await databaseService.unitradeCollection
        .doc(userId)
        .get()
        .then((value) {
      return value.data()['roles'];
    });

    return result;
  }

  Future<Widget> _getImage(BuildContext context, String imageUrl) async {
    Image productImage;
    return productImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getCurrentUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                //returns container for normal non-admin users
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: FutureBuilder(
                  future: _getImage(context, imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      switch (widget.productType) {
                        case TAB_PAINT_TEXT:
                          return _buildPaintList();
                          break;
                        case TAB_WOOD_TEXT:
                          return _buildWoodList();
                          break;
                        case TAB_SS_TEXT:
                          return _buildSolidSurfaceList();
                          break;
                        case TAB_LIGHT_TEXT:
                          return _buildLightList();
                          break;
                        case TAB_ACCESSORIES_TEXT:
                          return _buildAccessoriesList();
                          break;
                        case TAB_MACHINE_TEXT:
                          return _buildMachineList();
                        default:
                          return Container();
                          break;
                      }
                    }
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container(
                        height: 90.0,
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: Container(),
                      );
                    return Container();
                  },
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }

  //return container paint
  Widget _buildPaintList() {
    Map<String, dynamic> itemStock = new Map();
    stockChildren.clear();
    if (widget.product.inventory != null)
      widget.product.inventory.forEach((key, value) {
        if (value != 0) {
          itemStock = {key: value};
          stockChildren.add(Text('$key: $value'));
        }
      });
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    paintProducts: widget.product, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: [
            //Image field
            widget.product.imageLocalUrl != null
                ? Expanded(
                    flex: 4,
                    child: Image.asset(
                      widget.product.imageLocalUrl ?? '',
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: Image.asset('images/no_image.png'),
                  ),
            SizedBox(
              width: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            //Product name field
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.product.itemCode} - ${widget.product.productName}',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Packing field
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.productPack.toString(),
                    style: textStyle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    widget.product.productPackUnit,
                    style: textStyle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            //Price field
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.product.productPrice.toString()} SR',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Stock field
            itemStock.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(children: stockChildren),
                    ),
                  )
                : SizedBox.shrink(),
            widget.roles.contains('isSuperAdmin')
                ? Expanded(flex: 1, child: _buildUpdateDeleteButton(context))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  //return container wood
  Widget _buildWoodList() {
    Map<String, dynamic> itemStock = new Map();
    if (widget.woodProduct.inventory != null)
      widget.woodProduct.inventory.forEach((key, value) {
        if (value != 0) {
          itemStock = {key: value};
          stockChildren.add(Text('$key: $value'));
        }
      });

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    woodProduct: widget.woodProduct, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.woodProduct.imageListUrls.isNotEmpty
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            widget.woodProduct.imageListUrls[0] ?? ''),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Center(child: Text('No Image')),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  widget.woodProduct.productName,
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  'Dimensions:\n ${widget.woodProduct.length}x${widget.woodProduct.width}x${widget.woodProduct.thickness} mm\n',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Price field
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.woodProduct.productPrice.toString()} SR',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Stock field
            itemStock.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(children: stockChildren),
                    ),
                  )
                : SizedBox.shrink(),
            widget.roles.contains('isSuperAdmin')
                ? Expanded(child: _buildUpdateDeleteButton(context))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  //return container solid surface
  Widget _buildSolidSurfaceList() {
    Map<String, dynamic> itemStock = new Map();
    if (widget.woodProduct.inventory != null)
      widget.woodProduct.inventory.forEach((key, value) {
        if (value != 0) {
          itemStock = {key: value};
          stockChildren.add(Text('$key: $value'));
        }
      });
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    woodProduct: widget.woodProduct, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.woodProduct.imageListUrls.isNotEmpty
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            widget.woodProduct.imageListUrls[0] ?? ''),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.woodProduct.productName,
                    style: textStyle1,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: widget.woodProduct.thickness != null
                    ? new Text(
                        'Dimensions:\n ${widget.woodProduct.length}x${widget.woodProduct.width}x${widget.woodProduct.thickness} mm\n',
                        style: textStyle1,
                        textAlign: TextAlign.center,
                      )
                    : new Text(
                        'Packing: ${widget.woodProduct.productPack} ml',
                        style: textStyle1,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            //Price field
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.woodProduct.productPrice.toString()} SR',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Stock field
            itemStock.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(children: stockChildren),
                    ),
                  )
                : SizedBox.shrink(),
            widget.roles.contains('isSuperAdmin')
                ? Expanded(child: _buildUpdateDeleteButton(context))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  //return container lights
  Widget _buildLightList() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    lightProduct: widget.lightProduct, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.lightProduct.imageListUrls != null
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            widget.lightProduct.imageListUrls[0] ?? ''),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.lightProduct.productName,
                    style: textStyle1,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  '${widget.lightProduct.watt} W',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            widget.roles.contains('isSuperAdmin')
                ? Expanded(child: _buildUpdateDeleteButton(context))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  //return container accessories
  Widget _buildAccessoriesList() {
    Map<String, dynamic> itemStock = new Map();
    if (widget.accessoriesProduct.inventory != null)
      widget.accessoriesProduct.inventory.forEach((key, value) {
        if (value != 0) {
          itemStock = {key: value};
          stockChildren.add(Text('$key: $value'));
        }
      });

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    accessoriesProduct: widget.accessoriesProduct,
                    roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.accessoriesProduct.imageListUrls.isNotEmpty
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            widget.accessoriesProduct.imageListUrls[0] ?? ''),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.accessoriesProduct.productName,
                    style: textStyle1,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    widget.accessoriesProduct.length != null
                        ? Container(
                            child: Text(
                              '${widget.accessoriesProduct.length} mm',
                              style: textStyle1,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    widget.accessoriesProduct.angle != null
                        ? Container(
                            child: Text(
                              '${widget.accessoriesProduct.angle} degrees',
                              style: textStyle1,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                  ],
                )),
            //Price field
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.accessoriesProduct.productPrice.toString()} SR',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Stock field
            itemStock.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(children: stockChildren),
                    ),
                  )
                : SizedBox.shrink(),
            widget.roles.contains('isSuperAdmin')
                ? Expanded(child: _buildUpdateDeleteButton(context))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  //return container accessories
  Widget _buildMachineList() {
    Map<String, dynamic> itemStock = new Map();
    if (widget.machineProduct.inventory != null)
      widget.machineProduct.inventory.forEach((key, value) {
        if (value != 0) {
          itemStock = {key: value};
          stockChildren.add(Text('$key: $value'));
        }
      });

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    machineProduct: widget.machineProduct,
                    roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.machineProduct.imageListUrls.isNotEmpty
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(
                            widget.machineProduct.imageListUrls[0] ?? ''),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.machineProduct.productName,
                    style: textStyle1,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    widget.machineProduct.pressure != null
                        ? Text('${widget.machineProduct.pressure} bar')
                        : Text(''),
                    widget.machineProduct.ratio != null
                        ? Text(widget.machineProduct.ratio)
                        : Text(''),
                    widget.machineProduct.nozzle != null
                        ? Text('${widget.machineProduct.nozzle} ml')
                        : Text(''),
                    widget.machineProduct.length != null
                        ? Text('${widget.machineProduct.length} cm')
                        : Text(''),
                    widget.machineProduct.type != null
                        ? Text(widget.machineProduct.type)
                        : Text(''),
                  ],
                )),
            //Price field
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.machineProduct.productPrice.toString()} SR',
                  style: textStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Stock field
            itemStock.isNotEmpty
                ? Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(children: stockChildren),
                    ),
                  )
                : SizedBox.shrink(),
            widget.roles.contains('isSuperAdmin')
                ? Expanded(child: _buildUpdateDeleteButton(context))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  //Build the edit and delete buttons
  Widget _buildUpdateDeleteButton(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(ALERT_DELETE_PRODUCT),
                  content: Text(ALERT_DELETE_PRODUCT_CONTENT +
                      widget.productType +
                      ALERT_PRODUCT),
                  actions: [
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(ALERT_NO)),
                    new FlatButton(
                        onPressed: () async {
                          if (widget.productType == TAB_PAINT_TEXT)
                            await DatabaseService().deletePaintProduct(
                                uid: widget.product.uid,
                                imageUids: widget.product.imageListUrls);
                          else if (widget.productType == TAB_WOOD_TEXT)
                            await DatabaseService().deleteWoodProduct(
                                uid: widget.woodProduct.uid,
                                imageUids: widget.woodProduct.imageListUrls);
                          else if (widget.productType == TAB_SS_TEXT)
                            await DatabaseService().deletesolidSurfaceProduct(
                                uid: widget.woodProduct.uid,
                                imageUids: widget.woodProduct.imageListUrls);
                          else if (widget.productType == TAB_LIGHT_TEXT)
                            await DatabaseService().deleteLightsProduct(
                                uid: widget.lightProduct.uid,
                                imageUids: widget.lightProduct.imageListUrls);
                          else if (widget.productType == TAB_ACCESSORIES_TEXT)
                            await DatabaseService().deleteAccessoriesProduct(
                                uid: widget.accessoriesProduct.uid,
                                imageUids:
                                    widget.accessoriesProduct.imageListUrls);
                          else if (widget.productType == TAB_MACHINE_TEXT) {
                            await DatabaseService().deleteMachineProduct(
                              uid: widget.machineProduct.uid,
                              imageUids: widget.machineProduct.imageListUrls,
                            );
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(ALERT_YES))
                  ],
                );
              });
        },
      ),
    );
  }
}
