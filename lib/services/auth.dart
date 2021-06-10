import 'package:firebase_auth/firebase_auth.dart';
import 'package:unitrade_web_v2/models/user.dart' as localUser;
import 'package:unitrade_web_v2/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseService db = DatabaseService();
  var newUser;

  //create a user object based on Firebase user
  localUser.UserData _userFromFirebaseUser(User user) {
    return user != null ? localUser.UserData(uid: user.uid) : null;
  }

  //Verify user account
  userFromFirebaseVerification(String emailAddress) async {
    User user = _auth.currentUser;
    try {
      user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print('${this.runtimeType} sending verification failed: $e');
    }
  }

  //auth change user screen
  Stream<localUser.UserData> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with user name and password
  Future signInWithUserNameandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      User user = result.user;

      // if (user.emailVerified) {
      //   print('${this.runtimeType} current user is verified ${user.uid}');
      //   return 'User is verified';
      // } else {
      //   print('${this.runtimeType} current user is not verified ${user.uid}');
      //   return 'User not verified';
      // }
      return 'User is verified';
    } catch (e) {
      return e.toString();
    }
  }

  //register with email and password
  Future registerWithEmailandPassword(
      {String email,
      String password,
      String firstName,
      String lastName,
      String company,
      bool isActive,
      String phoneNumber,
      String countryOfResidence,
      String cityOfResidence,
      List<String> roles}) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;

      print('${this.runtimeType} current user: ${user.uid}');
      if (user != null) {
        await db
            .setUserData(
                uid: user.uid,
                firstName: firstName,
                lastName: lastName,
                company: company,
                phoneNumber: phoneNumber,
                isActive: false,
                emailAddress: email,
                countryOfResidence: countryOfResidence,
                cityOfResidence: cityOfResidence ?? '',
                roles: roles)
            .then((value) {
          print(value);
        });
        Future.delayed(Duration(seconds: 3));
        user = _auth.currentUser;
        try {
          print('${this.runtimeType} sending verification email for $user');
          await user.sendEmailVerification();
          return user.uid;
        } catch (e) {
          print('an error occured while sending verification email: $e');
        }
      }
    } catch (e) {
      print('Could not register error: ' + e.toString());
      return e.toString();
    }
  }

  //sign out
  Future signOut() async {
    try {
      print('${this.runtimeType} has signed out user: ${user.first}');
      return await _auth.signOut();
    } catch (e) {
      print('${this.runtimeType} couldn\'t sign out: ${e.toString()}');
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return '${this.runtimeType} Reset email error: $e';
    }
  }
}
