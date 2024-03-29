import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String uid;
  Brand({this.uid});
}

class Brands {
  final String uid;
  final String brand;
  final String countryOrigin;
  final List<dynamic> category;
  final String division;
  final String image;

  Brands(
      {this.uid,
      this.brand,
      this.countryOrigin,
      this.division,
      this.category,
      this.image});
}

class Product {
  final String uid;
  Product({this.uid});
}

class PaintMaterial {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String productPackUnit;
  double productPack;
  double productPrice;
  double productCost;
  String color;
  String description;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String imageLocalUrl;
  Map<String, dynamic> inventory;
  String pdfUrl;

  PaintMaterial(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.productPackUnit,
      this.productPack,
      this.productPrice,
      this.productCost,
      this.color,
      this.description,
      this.productTags,
      this.imageListUrls,
      this.imageLocalUrl,
      this.inventory,
      this.pdfUrl});
}

class WoodProduct {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  double length;
  double width;
  double thickness;
  double productPack;
  String color;
  String description;
  double productPrice;
  double productCost;
  Map<String, dynamic> inventory;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String pdfUrl;

  WoodProduct(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.width,
      this.thickness,
      this.productPack,
      this.color,
      this.description,
      this.productPrice,
      this.productCost,
      this.inventory,
      this.productTags,
      this.imageListUrls,
      this.pdfUrl});
}

class Lights {
  String uid;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String dimensions;
  String voltage;
  String watt;
  String color;
  String description;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;

  Lights(
      {this.uid,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.dimensions,
      this.voltage,
      this.watt,
      this.color,
      this.description,
      this.productTags,
      this.imageListUrls});
}

class Accessories {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  double length;
  double angle;
  String closingType;
  String color;
  String description;
  double productPrice;
  double productCost;
  String extensionType;
  String itemSide;
  String flapStrength;
  Map<String, dynamic> inventory;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String pdfUrl;
  Accessories(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.angle,
      this.closingType,
      this.itemSide,
      this.extensionType,
      this.flapStrength,
      this.inventory,
      this.color,
      this.description,
      this.productPrice,
      this.productCost,
      this.productTags,
      this.imageListUrls,
      this.pdfUrl});
}

class Machines {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String pressure;
  var nozzle;
  var length;
  String type;
  String ratio;
  String description;
  var productPrice;
  var productCost;
  Map<String, dynamic> inventory;
  List<dynamic> imageListUrls;
  String pdfUrl;

  Machines(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.pressure,
      this.nozzle,
      this.length,
      this.type,
      this.ratio,
      this.description,
      this.productCost,
      this.productPrice,
      this.inventory,
      this.imageListUrls,
      this.pdfUrl});
}

class Industrial {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  var length;
  var width;
  var thickness;
  String measureUnit;
  var productPack;
  var weight;
  String weightUnit;
  String color;
  String description;
  double productPrice;
  double productCost;
  Map<String, dynamic> inventory;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String pdfUrl;

  Industrial(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.width,
      this.thickness,
      this.measureUnit,
      this.weight,
      this.weightUnit,
      this.color,
      this.description,
      this.productPrice,
      this.productCost,
      this.inventory,
      this.productTags,
      this.imageListUrls,
      this.pdfUrl});
}

class Orders {
  String orderId;
  String userId;
  List<dynamic> orderProducts;
  String status;
  Timestamp date;
  Orders(
      {this.orderId, this.userId, this.orderProducts, this.date, this.status});
}

class QuoteItems {
  String itemCode;
  String itemPack;
  double quantity;
  double price;
  double tax;
  QuoteItems(
      {this.itemCode, this.itemPack, this.quantity, this.price, this.tax});
}
