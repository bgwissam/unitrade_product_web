//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/screens/authentication/sign_in.dart';
import 'package:unitrade_web_v2/screens/authentication/wrapper.dart';
import 'package:unitrade_web_v2/services/auth.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/string.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: MAIN_TITLE,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.amber,
            accentColor: Colors.amber[200]),
        home: MyHomePage(
          title: HOME_PAGE,
        ),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new Wrapper(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showSignInInput = false;
  double sizedBoxHeight = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                child: Image.asset(
                  'images/logo.png',
                  height: 300.0,
                  width: 800.0,
                ),
              ),
            ),
            Center(
              child: Container(
                color: Colors.deepOrange[400],
                width: 300.0,
                child: ElevatedButton(
                  child: Text(
                    SIGN_IN_TEXT,
                    style: buttonStyle,
                  ),
                  onPressed: () {
                    setState(() {
                      !showSignInInput
                          ? showSignInInput = true
                          : showSignInInput = false;
                    });
                  },
                ),
              ),
            ),
            showSignInInput
                ? Center(
                    child:
                        Container(height: 250.0, width: 300.0, child: SignIn()))
                : Center(
                    child: SizedBox(
                      height: 15.0,
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
