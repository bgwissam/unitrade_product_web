// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/models/brand.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/string.dart';
import 'package:unitrade_web_v2/shared/dropdownLists.dart';
import 'package:firebase/firebase.dart' as webFireStorage;
import 'package:image_whisperer/image_whisperer.dart' as whisperer;
import 'package:flutter/painting.dart' as painting;

class BrandForm extends StatefulWidget {
  final List<dynamic> roles;
  final Brand brand;
  BrandForm({this.roles, this.brand});
  @override
  _BrandFormState createState() => _BrandFormState();
}

class _BrandFormState extends State<BrandForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //Brand variables
  String brandName;
  String countryOfOrigin;
  String brandDivision;
  String brandCategory;
  List<String> brandCategories;
  String brandImageUrl;
  dynamic imageUrl;
  //hold the types of each business division
  List<String> divisionType;
  //Holds the category of each type
  List<String> category = [];
  //verifies if division is selected before showing the category
  bool productDivisionSelected = false;
  bool productCategorySelected = false;
  //Distance between rows
  double _sizedBoxHeigth = 15.0;
  Uint8List imageUpload;
  String errorText;
  painting.NetworkImage tempImage;
  File image;

  void initState() {
    super.initState();
    if (widget.brand != null) {
      brandName = widget.brand.brandName;
      countryOfOrigin = widget.brand.countryOfOrigin;
      brandDivision = widget.brand.brandDivision;
      brandCategories = widget.brand.brandCategories;
      brandImageUrl = widget.brand.brandImageUrl;

      category = CategoryList.categoryList(brandDivision);
    } else {
      brandCategories = [];
    }

    divisionType = Type.typeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ADD_BRAND),
        backgroundColor: Colors.amberAccent,
        elevation: 2.0,
      ),
      body: _userAuthorizationLevel(),
    );
  }

  //Widget to check user authorization
  Widget _userAuthorizationLevel() {
    //specify the page width in accordance to the screen
    double pageWidth = MediaQuery.of(context).size.width;
    if (widget.roles.contains('isAdmin')) {
      return SingleChildScrollView(
        child: new Form(
          key: _formKey,
          child:
              Container(width: pageWidth / 1.5, child: _buildBrandFormAdmin()),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: new Container(
          child: _buildNotAuthorizedForm(),
        ),
      );
    }
  }

  //Will show the adding a brand if the user is authorized
  Widget _buildBrandFormAdmin() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Brand Name
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(BRAND_NAME),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: brandName ?? '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  validator: (val) =>
                      val.isEmpty ? BRAND_NAME_VALIDATION_EMPTY : null,
                  onChanged: (val) {
                    setState(() {
                      brandName = val;
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: _sizedBoxHeigth,
          ),
          //Country of origin
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(BRAND_COUNTRY),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: countryOfOrigin ?? '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  validator: (val) =>
                      val.isEmpty ? BRAND_COUNTRY_VALIDATION_EMPTY : null,
                  onChanged: (val) {
                    setState(() {
                      countryOfOrigin = val;
                    });
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: _sizedBoxHeigth,
          ),
          //Brand division
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(BRAND_DIVISION),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: brandDivision ?? null,
                    hint: Text(SELECT_PRODUCT_TYPE),
                    onChanged: (String val) {
                      setState(() {
                        if (category.isNotEmpty) {
                          category.clear();
                        }
                        brandCategories.clear();
                        brandDivision = val;
                      });
                      category = CategoryList.categoryList(brandDivision);
                      productDivisionSelected = true;
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return divisionType.map<Widget>((String item) {
                        return Text(item, style: textStyle1);
                      }).toList();
                    },
                    items: divisionType.map((String item) {
                      return DropdownMenuItem<String>(
                          child: Text(item), value: item);
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: _sizedBoxHeigth,
          ),
          //Brand categories
          productDivisionSelected
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(BRAND_CATEGORIES),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          value: brandCategory,
                          hint: Text(SELECT_PRODUCT_CATEGORY),
                          onChanged: (String val) {
                            setState(() {
                              // brandCategory = val;
                              if (!brandCategories.contains(val))
                                brandCategories.add(val);
                            });
                            productCategorySelected = true;
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return category.map<Widget>((String item) {
                              return Text(item, style: textStyle1);
                            }).toList();
                          },
                          items: category.map((String item) {
                            return DropdownMenuItem<String>(
                                child: Text(item), value: item);
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(),
          //Brand categories selected list
          Row(children: [
            productCategorySelected
                ? Container(
                    height: 50.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: brandCategories.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: FlatButton(
                              color: Colors.grey[400],
                              child: Text(
                                brandCategories[index],
                                style: textStyle3,
                              ),
                              onPressed: () {
                                setState(() {
                                  brandCategories.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ]),
          SizedBox(
            height: _sizedBoxHeigth,
          ),
          //Image selector
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(8.0),
                  height: 220,
                  child: tempImage == null
                      ? Center(
                          child: Container(
                            margin: const EdgeInsets.all(4.0),
                            width: 800,
                            height: 200,
                            decoration: BoxDecoration(border: Border.all()),
                            child: InkWell(
                              child: Text(
                                'Tap to Add Image',
                                textAlign: TextAlign.center,
                              ),
                              onTap: () async {
                                _startImagesPicker();
                              },
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(4.0),
                          width: 800,
                          height: 200,
                          decoration: BoxDecoration(border: Border.all()),
                          child: InkWell(
                            child: showSelectedImage(),
                            onTap: () async {
                              _startImagesPicker();
                            },
                          ),
                        )),
            ],
          ),
          SizedBox(
            height: _sizedBoxHeigth,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: RaisedButton(
                  color: Colors.amber[400],
                  child: Text(SAVE_BRAND, style: buttonStyle),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var result;
                      DatabaseService databaseService = new DatabaseService();
                      if (widget.brand == null) {
                        setState(() {
                          loading = true;
                        });
                        await uploadImage(image);

                        result = await databaseService.addBrandData(
                            brandName: brandName,
                            countryOfOrigin: countryOfOrigin,
                            category: brandCategories,
                            division: brandDivision,
                            imageUrl: imageUrl);
                        print('the current result is: $result');
                        if (result != null) {
                          loading = false;
                        }
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //Will show this form if the user is not authorized
  Widget _buildNotAuthorizedForm() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: Container(
          child: Text(
            NOT_AUTHORIZED,
            style: textStyle1,
          ),
        ),
      ),
    );
  }

  //get Images for local strage
  Future<painting.NetworkImage> _startImagesPicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      //Read file content as dataUrl
      final files = uploadInput.files;
      if (files.length == 1) {
        image = files[0];
        FileReader reader = FileReader();
        reader.onLoadEnd.listen((event) {
          setState(() {
            imageUpload = reader.result;
          });
        });
        reader.onError.listen((event) {
          setState(() {
            errorText = 'The following error occured: $event';
          });
        });
        reader.readAsArrayBuffer(image);
        whisperer.BlobImage blobImage =
            new whisperer.BlobImage(image, name: image.name);
        setState(() {
          tempImage = painting.NetworkImage(blobImage.url);
        });
      }
    });
    return tempImage;
  }

  //Image upload widget
  Widget showSelectedImage() {
    if (tempImage != null)
      return Container(
          child: Image.network(
        tempImage.url,
        height: 200.0,
        width: 200.0,
      ));
    else
      return Container(
        child: Text(CANNOT_READ_IMAGE, textAlign: TextAlign.center),
        height: 200.0,
        width: 200.0,
      );
  }

  //Upload image to firebase Storage
  Future uploadImage(File selectedImage) async {
    webFireStorage.StorageReference storageReference;
    String folderNameImages = 'image';

    if (image != null) {
      storageReference = webFireStorage
          .storage()
          .ref()
          .child('$folderNameImages/${image.name}');

      webFireStorage.UploadTaskSnapshot uploadTaskSnapshot =
          await storageReference.put(image).future;

      Uri currentImageUrl = await uploadTaskSnapshot.ref.getDownloadURL();
      print('The new images are: $imageUrl');
      imageUrl = currentImageUrl.toString();
    }
  }
}
