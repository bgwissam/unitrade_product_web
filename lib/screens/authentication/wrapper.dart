import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/screens/home/home.dart';
import 'package:unitrade_web_v2/shared/loading.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context) ?? null;
    
    if (userData == null) {
      return Loading();
    } else {
      return Home(userId: userData.uid,);
    }
  }
}
