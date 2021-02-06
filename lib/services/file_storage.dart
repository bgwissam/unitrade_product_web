import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadFromStorage(
      BuildContext context, String image) async {
    try {
      var ref = await FirebaseStorage.instance.ref().child(image)
      .getDownloadURL().then((value){
        print('The url is $value');
      });
      return ref;
    } catch (e) {
      print('Can\'t obtain the image: $e');
      return image;
    }
  }
  
}
