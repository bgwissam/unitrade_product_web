import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/screens/authentication/wrapper.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import '../../shared/string.dart';

class SignedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SIGNED_OUT_USER_PAGE,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, accentColor: Colors.black54),
      home: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 120.0, horizontal: 120.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  child: Text(
                    SINGED_OUT_TEXT,
                    style: titleTextStyle,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Center(
                child: Container(
                  child: RaisedButton(
                    child: Text(SIGN_IN_AGAIN),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.black)),
                    textColor: Colors.black,
                    color: Colors.blueGrey[200],
                    padding: EdgeInsets.all(15.0),
                    disabledColor: Colors.grey[600],
                    disabledElevation: 0.0,
                    elevation: 5.0,
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => new Wrapper())),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
