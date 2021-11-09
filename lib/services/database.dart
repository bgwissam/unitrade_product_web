import 'package:firebase_storage/firebase_storage.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/models/products.dart';
import 'package:unitrade_web_v2/models/brand.dart' as brand;
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference unitradeCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference brandCollection =
      FirebaseFirestore.instance.collection('brands');
  final CollectionReference paintCollection =
      FirebaseFirestore.instance.collection('paint');
  final CollectionReference woodCollection =
      FirebaseFirestore.instance.collection('wood');
  final CollectionReference solidCollection =
      FirebaseFirestore.instance.collection('solid');
  final CollectionReference machineCollection =
      FirebaseFirestore.instance.collection('machines');
  final CollectionReference lightsCollection =
      FirebaseFirestore.instance.collection('lights');
  final CollectionReference accessoriesCollection =
      FirebaseFirestore.instance.collection('accessories');
  final CollectionReference industrialCollection =
      FirebaseFirestore.instance.collection('industrial');
  final CollectionReference clientCollection =
      FirebaseFirestore.instance.collection('clients');
  final CollectionReference salesPipeline =
      FirebaseFirestore.instance.collection('sales_pipeline');
  final CollectionReference quotationCollection =
      FirebaseFirestore.instance.collection('quotes');

  //Add a new user to the users database
  Future<String> addUserData(
      {String uid,
      String firstName,
      String lastName,
      String company,
      bool isActive,
      String phoneNumber,
      String emailAddress,
      String countryOfResidence,
      String cityOfResidence,
      List<dynamic> roles,
      List<dynamic> usersAccessList}) async {
    try {
      return await unitradeCollection.add({
        'firstName': firstName,
        'lastName': lastName,
        'company': company,
        'isActive': isActive,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'countryOfResidence': countryOfResidence,
        'cityOfResidence': cityOfResidence,
        'roles': roles,
        'userAccessList': usersAccessList,
      }).then((value) {
        return 'your data has been updated successfully $value';
      });
    } catch (e) {
      return 'An error occured: $e';
    }
  }

  //Update the user data
  Future<String> setUserData(
      {String uid,
      String firstName,
      String lastName,
      String company,
      bool isActive,
      String phoneNumber,
      String emailAddress,
      String countryOfResidence,
      String cityOfResidence,
      List<dynamic> roles,
      List<dynamic> usersAccessList}) async {
    try {
      return await unitradeCollection.doc(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'company': company,
        'isActive': isActive,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'countryOfResidence': countryOfResidence,
        'cityOfResidence': cityOfResidence,
        'roles': roles,
        'userAccessList': usersAccessList,
      }).then((value) {
        return 'your data has been updated successfully';
      });
    } catch (e) {
      return ' $e';
    }
  }

  //User data from snapshot
  List<UserData> _userDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((snapshot) {
      return UserData(
          uid: uid,
          firstName: snapshot.data()['firstName'] ?? '',
          lastName: snapshot.data()['lastName'] ?? '',
          company: snapshot.data()['company'] ?? '',
          phonNumber: snapshot.data()['phoneNumber'],
          countryOfResidence: snapshot.data()['countryOfResidence'],
          cityOfResidence: snapshot.data()['cityOfResidnce'],
          isActive: snapshot.data()['isActive'] ?? true,
          roles: snapshot.data()['roles'] ?? null,
          usersAccessList: snapshot.data()['usersAccessList']);
    }).toList();
  }

  Future<String> getUserById(String userId) async {
    return await unitradeCollection.doc(userId).get().then((value) {
      return '${value.data()['firstName']} ${value.data()['lastName']}';
    });
  }

  //get user doc stream
  Stream<List<UserData>> get userData {
    return unitradeCollection.snapshots().map(_userDataFromSnapshot);
  }

  //get normal users only
  Stream<List<UserData>> getNormalUsers() {
    return unitradeCollection
        .where('roles', arrayContains: 'isNormalUser')
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //This section is to manage brand data
  //add a new brand
  Future addBrandData(
      {String brandName,
      String countryOfOrigin,
      String division,
      List<dynamic> category,
      String imageUrl}) async {
    try {
      brandCollection.add({
        'brandName': brandName,
        'countryOfOrigin': countryOfOrigin,
        'category': category ?? '',
        'division': division ?? '',
        'imageUrl': imageUrl ?? '',
      }).then((val) => print('The Brand is saved'));
    } catch (e) {
      print('could not add brand: ' + e.toString());
    }
  }

  //update current brand
  Future updateBrandData(
      {String uid,
      String brandName,
      String countryOfOrigin,
      String division,
      List<dynamic> category,
      String imageUrl}) async {
    try {
      brandCollection.doc(uid).set({
        'brandName': brandName,
        'countryOfOrigin': countryOfOrigin,
        'division': division ?? '',
        'category': category ?? '',
        'imageUrl': imageUrl ?? '',
      });
    } catch (e) {
      print('could not update brand: ' + e.toString());
    }
  }

  //Brand data from snapshot
  List<Brands> _brandDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brands(
          uid: doc.id,
          brand: doc.data()['brandName'] ?? '',
          countryOrigin: doc.data()['countryOfOrigin'] ?? '',
          division: doc.data()['division'] ?? '',
          category: doc.data()['category'] ?? null,
          image: doc.data()['imageUrl'] ?? '');
    }).toList();
  }

  //Brand data from snapshot for product drop downlist
  Future<List<Brands>> brandDataForDropdownMenu() async {
    List<Brands> brands = [];
    try {
      QuerySnapshot brandDoc = await brandCollection.get();
      brandDoc.docs.map((doc) {
        Brands(
            uid: doc.id,
            brand: doc.data()['brandName'] ?? '',
            countryOrigin: doc.data()['countryOfOrigin'] ?? '',
            division: doc.data()['division'] ?? '',
            category: doc.data()['category'],
            image: doc.data()['imageUrl'] ?? '');
      });
      print(brands);
      return brands;
    } catch (e) {
      print('Could not retreive the brand list data $e');
      return null;
    }
  }

  //Delete Brand from database
  Future deleteBrandData(String uid, String imageUid) async {
    try {
      await brandCollection.doc(uid).delete();
      await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('could not delete due to: $e');
    }
  }

  //get all brands
  Future<List<brand.Brand>> getAllBrands() async {
    try {
      List<brand.Brand> brands = [];
      QuerySnapshot brandDoc = await brandCollection.get();

      brandDoc.docs.map((doc) {
        brands.add(brand.Brand(
            id: doc.id,
            brandName: doc.data()['brandName'],
            brandDivision: doc.data()['division'],
            brandCategories: doc.data()['brandCategory'],
            countryOfOrigin: doc.data()['countryOfOrigin'],
            brandImageUrl: doc.data()['imageUrl']));
      }).toList();
      return brands;
    } catch (e) {
      return null;
    }
  }

  //get brands doc from Stream
  Stream<List<Brands>> get brands {
    return brandCollection.snapshots().map(_brandDataFromSnapshot);
  }

  //get brands depending on category
  Stream<List<Brands>> categoryBrands(String category) {
    return brandCollection
        .where('category', arrayContainsAny: [
          category,
          category.toLowerCase(),
          category.toUpperCase()
        ])
        .snapshots()
        .map(_brandDataFromSnapshot);
  }

  //This part will involve data regarding client and transactions
  //against them.
  //Add clients to the database
  Future addClient(
      {String clientName,
      String clientPhone,
      String clientAddress,
      String clientSector,
      String email,
      String salesInCharge}) async {
    try {
      return clientCollection.add({
        'clientName': clientName,
        'clientPhone': clientPhone,
        'clientAddress': clientAddress,
        'clientSector': clientSector,
        'clientEmail': email,
        'salesInCharge': salesInCharge
      }).then((value) => value);
    } catch (e) {
      print('An error occured in adding the client: $e');
    }
  }

  //Update client data
  Future updateClient(
      {String uid,
      String clientName,
      String clientPhone,
      String clientAddress,
      String clientSector,
      String email}) async {
    try {
      return clientCollection.doc(uid).update({
        'clientName': clientName,
        'clientPhone': clientPhone,
        'clientAddress': clientAddress,
        'clientSector': clientSector,
        'clientEmail': email,
      }).then((value) => value);
    } catch (e) {
      print('Client could not be updated: $e');
    }
  }

  //Delete client from database to be done only by admin users
  Future deleteClient({String uid, bool isAdmin}) async {
    try {
      if (isAdmin) {
        return await clientCollection
            .doc(uid)
            .delete()
            .then((value) => print('Client was successfully deleted'));
      }
      return;
    } catch (e) {
      print('Client could not be deleted');
    }
  }

  //Get client by client Id
  Future getClientbyClientId({String clientUid}) async {
    try {
      var currentClient = Clients();
      return await clientCollection.doc(clientUid).get().then((value) {
        currentClient = Clients(
          clientName: value.data()['clientName'],
          clientBusinessSector: value.data()['clientSector'],
          clientGoogleAddress: value.data()['clientLocation'],
          clientPhoneNumber: value.data()['clientPhone'],
          lcNumber: value.data()['clientLcNumber'],
          imageUrls: value.data()['imageUrls'],
          salesInCharge: value.data()['salesInCharge'],
        );
        return currentClient;
      });
    } catch (e) {
      print('Client could not be retreived: $e');
    }
  }

  //get client from database
  List<Clients> _clientDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Clients(
          uid: doc.id,
          clientName: doc.data()['clientName'],
          clientPhoneNumber: doc.data()['clientPhone'],
          clientCity: doc.data()['clientAddress'],
          clientBusinessSector: doc.data()['clientSector'],
          email: doc.data()['clientEmail'],
          salesInCharge: doc.data()['salesInCharge']);
    }).toList();
  }

  //Stream client data by client id
  Stream<List<Clients>> clientDataById({String uid}) {
    return clientCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //Stream client data by client name
  Stream<List<Clients>> clientDatabyName({String clientName}) {
    return clientCollection
        .where('clientName', isEqualTo: clientName)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //Stream all client from the database
  Stream<List<Clients>> get allClients {
    return clientCollection.snapshots().map(_clientDataFromSnapshot);
  }

  //Stream clients for a particular sales person
  Stream<List<Clients>> clientDataBySalesId({String salesId}) {
    return clientCollection
        .where('salesInCharge', isEqualTo: salesId)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //Stream client email for selected client
  Stream<List<Clients>> clientEmailByName({String name}) {
    return clientCollection
        .where('clientName', isEqualTo: name)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //This section is for managing products by type
  //depending on the type of the product selected we update a different collection
  //Add a new paint product
  Future addPaintProduct(
      {String itemCode,
      String productName,
      String productBrand,
      String productType,
      String productPackUnit,
      double productPack,
      double productPrice,
      double productCost,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String imageLocalUrl,
      String pdfUrl}) async {
    try {
      paintCollection.add({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'productPackUnit': productPackUnit,
        'productPackValue': productPack,
        'productPrice': productPrice,
        'productCost': productCost,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'imageLocalUrl': imageLocalUrl,
        'pdfUrl': pdfUrl
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current paint product
  Future updatePaintProduct(
      {String uid,
      String itemCode,
      String productName,
      String productBrand,
      String productType,
      String productPackUnit,
      double productPack,
      double productPrice,
      double productCost,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String imageLocalUrl,
      String pdfUrl}) async {
    try {
      return paintCollection.doc(uid).set({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'productPackUnit': productPackUnit,
        'productPackValue': productPack,
        'productPrice': productPrice,
        'productCost': productCost,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'imageLocalUrl': imageLocalUrl,
        'pdfUrl': pdfUrl
      }).then((value) => print('Paint data updated'));
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Update only the price field
  Future updatePaintPriceField({String uid, double productPrice}) async {
    await paintCollection.doc(uid).update({'productPrice': productPrice}).then(
        (value) => print('Product price updated'));
  }

  //Delete a paint product
  Future deletePaintProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await paintCollection.doc(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get a list of paint product
  List<PaintMaterial> _productDataFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PaintMaterial(
          uid: doc.id,
          itemCode: doc.data()['itemCode'],
          productName: doc.data()['productName'],
          productBrand: doc.data()['productBrand'],
          productType: doc.data()['productType'],
          productPackUnit: doc.data()['productPackUnit'],
          productPack: doc.data()['productPackValue'],
          productPrice: doc.data()['productPrice'],
          productCost: doc.data()['productCost'],
          productCategory: doc.data()['productCategory'],
          color: doc.data()['color'],
          description: doc.data()['description'],
          productTags: doc.data()['tags'],
          imageListUrls: doc.data()['imageListUrls'],
          imageLocalUrl: doc.data()['imageLocalUrl'],
          inventory: doc.data()['inventory'],
          pdfUrl: doc.data()['pdfUrl']);
    }).toList();
  }

  //Stream data from paint document
  Stream<List<PaintMaterial>> paintProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTag,
      String productColor}) {
    var color;
    if (productColor == 'clear') {
      color = 'CLEAR';
    } else if (productColor == 'pigmented') {
      color = 'WHITE';
    } else {
      color = null;
    }
    return paintCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .where('color', isEqualTo: color)
        .snapshots()
        .map(_productDataFromSnapShot);
  }

  //Stream data from paint document using a tag
  Stream<List<PaintMaterial>> paintProductsTags({String tags}) {
    Stream<QuerySnapshot> stream = paintCollection
        .orderBy('productName')
        .startAt([tags.toUpperCase()]).endAt([tags + '\uf8ff']).snapshots();
    return stream.map(_productDataFromSnapShot);
  }

  //Stream data from paint document reference to its id
  Stream<List<PaintMaterial>> paintProductId(String uid) {
    return paintCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_productDataFromSnapShot);
  }

  //Stream all paint product
  Stream<List<PaintMaterial>> get allPaintProduct {
    return paintCollection.snapshots().map(_productDataFromSnapShot);
  }

  //Section for wood products
  //Adding a new wood product
  Future addWoodProduct(
      {String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double width,
      double thickness,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String pdfUrl}) async {
    try {
      woodCollection.add({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'pdfUrl': pdfUrl
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current wood product
  Future updateWoodProduct(
      {String uid,
      String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double width,
      double thickness,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String pdfUrl}) async {
    try {
      woodCollection.doc(uid).set({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'pdfUrl': pdfUrl
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current wood product
  Future deleteWoodProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await woodCollection.doc(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of wood product
  List<WoodProduct> _woodProductDataFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return WoodProduct(
          uid: doc.id,
          itemCode: doc.data()['itemCode'],
          productName: doc.data()['productName'],
          productBrand: doc.data()['productBrand'],
          productType: doc.data()['productType'],
          length: doc.data()['length'],
          width: doc.data()['width'],
          thickness: doc.data()['thickness'],
          productCategory: doc.data()['productCategory'],
          color: doc.data()['color'],
          description: doc.data()['description'],
          productPrice: doc.data()['productPrice'],
          productCost: doc.data()['productCost'],
          productTags: doc.data()['tags'],
          imageListUrls: doc.data()['imageListUrls'],
          inventory: doc.data()['inventory'],
          pdfUrl: doc.data()['pdfUrl']);
    }).toList();
  }

  //Stream data from wood document
  Stream<List<WoodProduct>> woodProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return woodCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_woodProductDataFromSnapShot);
  }

  //Stream data from paint document using a tag
  Stream<List<WoodProduct>> woodProductsTags({String tags}) {
    Stream<QuerySnapshot> stream = woodCollection
        .orderBy('productName')
        .startAt([tags.toUpperCase()]).endAt([tags + '\uf8ff']).snapshots();
    return stream.map(_woodProductDataFromSnapShot);
  }

  //Stream data from wood collection reference to its id
  Future<List<WoodProduct>> woodProductIdList(String uid) async {
    var document;
    try {
      document = await woodCollection.doc(uid).get();
      print('the received docuement $document');
    } catch (e) {
      print(e);
    }

    return document;
  }

  //stream wood products by id
  Stream<List<WoodProduct>> woodProductId(String uid) {
    return woodCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_woodProductDataFromSnapShot);
  }

  //get all wood products
  Stream<List<WoodProduct>> get allWoodProduct {
    return woodCollection.snapshots().map(_woodProductDataFromSnapShot);
  }

  //Section for solid surface products
  //adding a new solid surface product
  Future addSolidSurfaceProduct(
      {String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double width,
      double thickness,
      double productPack,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String pdfUrl}) async {
    try {
      solidCollection.add({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productPack': productPack,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'pdfUrl': pdfUrl,
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current wood product
  Future updateSolidSurfaceProduct(
      {String uid,
      String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double width,
      double thickness,
      double productPack,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String pdfUrl}) async {
    try {
      print(productPack);
      solidCollection.doc(uid).set({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productPack': productPack,
        'productCategory': productCategory,
        'productPrice': productPrice,
        'productCost': productCost,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'pdfUrl': pdfUrl,
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current solid surface product
  Future deletesolidSurfaceProduct(
      {String uid, List<dynamic> imageUids}) async {
    try {
      await solidCollection.doc(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of solid surface product
  List<WoodProduct> _solidSurfcaeProductDataFromSnapShot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return WoodProduct(
          uid: doc.id,
          itemCode: doc.data()['itemCode'],
          productName: doc.data()['productName'],
          productBrand: doc.data()['productBrand'],
          productType: doc.data()['productType'],
          length: doc.data()['length'],
          width: doc.data()['width'],
          thickness: doc.data()['thickness'],
          productPack: doc.data()['productPack'],
          productCategory: doc.data()['productCategory'],
          color: doc.data()['color'],
          description: doc.data()['description'],
          productPrice: doc.data()['productPrice'],
          productCost: doc.data()['productCost'],
          productTags: doc.data()['tags'],
          imageListUrls: doc.data()['imageListUrls'],
          inventory: doc.data()['inventory'],
          pdfUrl: doc.data()['pdfUrl']);
    }).toList();
  }

  //Stream data from solid surface document
  Stream<List<WoodProduct>> solidSurfaceProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return solidCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_solidSurfcaeProductDataFromSnapShot);
  }

  //Stream item from solid surface document reference to its id
  Stream<List<WoodProduct>> solidSurfaceProductId(String uid) {
    return solidCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_solidSurfcaeProductDataFromSnapShot);
  }

  //Sections for light products
  //Adding light products
  Future addLightsProduct(
      {String productName,
      String productBrand,
      String productType,
      String dimensions,
      String watt,
      String voltage,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      lightsCollection.add({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'dimenions': dimensions,
        'watt': watt,
        'voltage': voltage,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current light product
  Future updateLightsProduct(
      {String uid,
      String productName,
      String productBrand,
      String productType,
      String productCategory,
      String dimensions,
      String voltage,
      String watt,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      lightsCollection.doc(uid).set({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'productCategory': productCategory,
        'dimensions': dimensions,
        'voltage': voltage,
        'watt': watt,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current light product
  Future deleteLightsProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await lightsCollection.doc(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of lights product
  List<Lights> _lightsProductDataFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Lights(
          uid: doc.id,
          productName: doc.data()['productName'],
          productBrand: doc.data()['productBrand'],
          productType: doc.data()['productType'],
          dimensions: doc.data()['dimensions'],
          voltage: doc.data()['voltage'],
          watt: doc.data()['watt'],
          productCategory: doc.data()['productCategory'],
          color: doc.data()['color'],
          description: doc.data()['description'],
          productTags: doc.data()['tags'],
          imageListUrls: doc.data()['imageListUrls']);
    }).toList();
  }

  //Stream data from lights document
  Stream<List<Lights>> lightsProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return lightsCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_lightsProductDataFromSnapShot);
  }

  //Stream item from lights document reference to its id
  Stream<List<Lights>> lightsProductId(String uid) {
    return lightsCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_lightsProductDataFromSnapShot);
  }

  //Section for Accessories
  //Adding Accessories products
  Future addAccessoriesProduct(
      {String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double angle,
      String closingType,
      String itemSide,
      String extensionType,
      String flapStrength,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      accessoriesCollection.add({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'angle': angle,
        'closingType': closingType,
        'itemSide': itemSide,
        'extensionType': extensionType,
        'flapStrength': flapStrength,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current accessory product
  Future updateAccessoriesProduct(
      {String uid,
      String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double angle,
      String closingType,
      String itemSide,
      String extensionType,
      String flapStrength,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      accessoriesCollection.doc(uid).set({
        'itemCode': itemCode.trim(),
        'productName': productName.trim(),
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'angle': angle,
        'closingType': closingType,
        'itemSide': itemSide,
        'extensionType': extensionType,
        'flapStrength': flapStrength,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current accessory product
  Future deleteAccessoriesProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await accessoriesCollection.doc(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of accessory product
  List<Accessories> _accessoriesProductDataFromSnapShot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Accessories(
          uid: doc.id,
          itemCode: doc.data()['itemCode'],
          productName: doc.data()['productName'],
          productBrand: doc.data()['productBrand'],
          productType: doc.data()['productType'],
          length: doc.data()['length'],
          angle: doc.data()['angle'],
          closingType: doc.data()['closingType'],
          itemSide: doc.data()['itemSide'],
          extensionType: doc.data()['extensionType'],
          flapStrength: doc.data()['flapStrength'],
          productCategory: doc.data()['productCategory'],
          color: doc.data()['color'],
          description: doc.data()['description'],
          productPrice: doc.data()['productPrice'],
          productCost: doc.data()['productCost'],
          productTags: doc.data()['tags'],
          inventory: doc.data()['inventory'],
          imageListUrls: doc.data()['imageListUrls']);
    }).toList();
  }

  //Stream data from accessories document
  Stream<List<Accessories>> accessoriesProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return accessoriesCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_accessoriesProductDataFromSnapShot);
  }

  //Stream item from accessories document reference to its id
  Stream<List<Accessories>> accessoriesProductId(String uid) {
    return accessoriesCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_accessoriesProductDataFromSnapShot);
  }

  //Section for Spray machines
  //Add new product (machines)
  Future addMachineProduct({
    String itemCode,
    String productName,
    String productType,
    String productCategory,
    String productBrand,
    var pressure,
    var nozzle,
    var length,
    String type,
    String ratio,
    String description,
    var productPrice,
    var productCost,
    List<dynamic> imageListUrls,
    String pdfUrl,
  }) async {
    try {
      machineCollection.add({
        'itemCode': itemCode,
        'productName': productName,
        'productType': productType,
        'productCategory': productCategory,
        'productBrand': productBrand,
        'pressure': pressure,
        'nozzle': nozzle,
        'length': length,
        'type': type,
        'ratio': ratio,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'imageListUrls': imageListUrls,
        'pdfUrl': pdfUrl,
      });
    } catch (e) {
      print('Could not add machine item to database: $e');
    }
  }

  //Update current machine product
  Future updateMachineProduct({
    String uid,
    String itemCode,
    String productName,
    String productType,
    String productCategory,
    String productBrand,
    var pressure,
    var nozzle,
    var length,
    String ratio,
    String type,
    String description,
    var productPrice,
    var productCost,
    List<dynamic> imageListUrls,
    String pdfUrl,
  }) async {
    try {
      machineCollection.doc(uid).set({
        'itemCode': itemCode,
        'productName': productName,
        'productType': productType,
        'productCategory': productCategory,
        'productBrand': productBrand,
        'pressure': pressure,
        'nozzle': nozzle,
        'length': length,
        'type': type,
        'ratio': ratio,
        'description': description,
        'productPrice': productPrice,
        'productCost': productCost,
        'imageListUrls': imageListUrls,
        'pdfUrl': pdfUrl,
      });
    } catch (e) {
      print('Could not update machine database: $e');
    }
  }

  //Stream machine data
  List<Machines> _machineDataProductsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Machines(
          uid: doc.id,
          itemCode: doc.data()['itemCode'],
          productName: doc.data()['productName'],
          productBrand: doc.data()['productBrand'],
          productType: doc.data()['productType'],
          productCategory: doc.data()['productCategory'],
          productPrice: doc.data()['productPrice'],
          productCost: doc.data()['productCost'],
          pressure: doc.data()['pressure'],
          length: doc.data()['length'],
          type: doc.data()['type'],
          ratio: doc.data()['ratio'],
          nozzle: doc.data()['nozzle'],
          inventory: doc.data()['inventory'],
          imageListUrls: doc.data()['imageListUrls']);
    }).toList();
  }

  Stream<List<Machines>> machineProducts(
      {String brandName, String productType, String productCategory}) {
    return machineCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_machineDataProductsFromSnapshot);
  }

  //Delete current machine product
  Future deleteMachineProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await machineCollection.doc(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance.ref(imageUid).delete();
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Section for Industrial Products
  //Add a new Product
  Future addIndustrialProduct(
      {String itemCode,
      String productName,
      String productBrand,
      String productType,
      double length,
      double width,
      double thickness,
      double measureUnit,
      double weight,
      String weightUnit,
      String productCategory,
      String color,
      String description,
      double productPrice,
      double productCost,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String pdfUrl}) async {
    try {
      industrialCollection.add({
        'itemCode': itemCode,
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        measureUnit ?? 'measureUnit': measureUnit,
        'weight': weight,
        'weightUnut': weightUnit,
        'productCategory': productCategory,
        productPrice ?? 'productPrice': productPrice,
        productCost ?? 'productCost': productCost,
        'description': description,
        imageListUrls ?? 'imageListUrls': imageListUrls,
      });
    } catch (e) {
      print('Product could not be added: $e');
    }
  }

  //Update a current Product
  Future updateIndustrialProduct({
    String uid,
    String itemCode,
    String productName,
    String productBrand,
    String productType,
    double length,
    double width,
    double thickness,
    double measureUnit,
    double weight,
    String weightUnit,
    String productCategory,
    String color,
    String description,
    double productPrice,
    double productCost,
    List<dynamic> imageListUrls,
  }) async {
    try {
      industrialCollection.doc(uid).set({
        'itemCode': itemCode,
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        measureUnit ?? 'measureUnit': measureUnit,
        'weight': weight,
        'weightUnit': weightUnit,
        'productCategory': productCategory,
        productPrice ?? 'productPrice': productPrice,
        productCost ?? 'productCost': productCost,
        'description': description,
        imageListUrls ?? 'imageListUrls': imageListUrls,
      });
    } catch (e) {
      print('Product could not be updated: $e');
    }
  }

  //Read a product
  List<Industrial> _industrialDataProductsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Industrial(
        uid: doc.id,
        itemCode: doc.data()['itemCode'],
        productName: doc.data()['productName'],
        productBrand: doc.data()['productBrand'],
        productType: doc.data()['productType'],
        length: doc.data()['length'],
        width: doc.data()['width'],
        thickness: doc.data()['thickness'],
        measureUnit: doc.data()['productPack'],
        weight: doc.data()['weight'],
        weightUnit: doc.data()['weightUnit'],
        productCategory: doc.data()['productCategory'],
        color: doc.data()['color'],
        description: doc.data()['description'],
        productPrice: doc.data()['productPrice'],
        productCost: doc.data()['productCost'],
        imageListUrls: doc.data()['imageListUrls'],
        inventory: doc.data()['inventory'],
      );
    }).toList();
  }

  //Stream industrial product
  Stream<List<Industrial>> industrialProducts(
      {String brandName, String productType, String productCategory}) {
    return machineCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_industrialDataProductsFromSnapshot);
  }

  //Delete a product

  //Update sales pipline comment sent value
  Future updateCommentStatus(String uid) async {
    try {
      salesPipeline.doc(uid).update({
        'commentsSent': true,
      });
    } catch (e) {}
  }

  //This section will cover the sales pipeline collection
  List<SalesPipeline> _salespiplineDataFromSnaptshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SalesPipeline(
        uid: doc.id,
        clientId: doc.data()['clientId'],
        clientName: doc.data()['clientName'],
        visitDate: doc.data()['currentDate'],
        salesId: doc.data()['userId'],
        visitDetails: doc.data()['visitDetails'],
        visitPurpose: doc.data()['visitPurpose'],
        purposeLabel: doc.data()['purposeLabel'],
        purposeValue: doc.data()['purposeValue'],
        managerComments: doc.data()['managerComment'],
      );
    }).toList();
  }

  //Stream data per user
  Stream<List<SalesPipeline>> userDataById({String userId}) {
    return salesPipeline
        .where('userId', isEqualTo: userId)
        .orderBy('currentDate', descending: false)
        .snapshots()
        .map(_salespiplineDataFromSnaptshot);
  }

  //Stream data for all users
  Stream<List<SalesPipeline>> allUsersData() {
    return salesPipeline
        .orderBy('currentDate', descending: false)
        .snapshots()
        .map(_salespiplineDataFromSnaptshot);
  }
}
