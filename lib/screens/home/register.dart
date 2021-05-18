import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unitrade_web_v2/services/auth.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/country_drop_down.dart';
import 'package:unitrade_web_v2/shared/loading.dart';
import 'package:unitrade_web_v2/shared/string.dart';
import 'package:email_validator/email_validator.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String firstName = '';
  String lastName = '';
  String company = '';
  String email = '';
  String confirmEmail = '';
  String phoneNumber = '';
  String countryOfResidence = '';
  String cityOfResidence = '';
  String password = '';
  String error = '';
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.amber[400],
              elevation: 0.0,
              title: Text(
                REGISTER_USER,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    //First Name
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(FIRST_NAME),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? FIRST_NAME_VALIDATION : null,
                              onChanged: (val) {
                                setState(() {
                                  firstName = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    //Last Name
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(LAST_NAME),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? LAST_NAME_VALIDATION : null,
                              onChanged: (val) {
                                setState(() {
                                  lastName = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    //Nationality
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(NATIONALITY),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: CountryDropDownPicker()),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 40,
                      thickness: 3,
                    ),
                    //Company
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(COMPANY),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  company = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    //Mobile Number
                    Container(
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text(PHONE_NUMBER)),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                ),
                                validator: (val) {
                                  Pattern pattern = r'^(?:[05]8)?[0-9]{10}$';
                                  RegExp regexp = new RegExp(pattern);
                                  if (val.isEmpty) {
                                    return PHONE_NUMBER_VALIDATION;
                                  }
                                  if (!regexp.hasMatch(val)) {
                                    return PHONE_NUMBER_PATTERN_VALIDATION;
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    phoneNumber = val;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Divider(
                      height: 40,
                      thickness: 3,
                    ),
                    //Email Address
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(EMAIL_ADDRESS),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return EMAIL_ADDRESS_EMPTY;
                                }
                                if (!EmailValidator.validate(val)) {
                                  return EMAIL_ADDRESS_VALIDATION;
                                } else
                                  return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    //Confirm email address
                    Container(
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text(CONFIRM_EMAIL)),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (val) =>
                                  val != email ? CONFIRM_EMAIL_MATCHING : null,
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    //Password
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(PASSWORD),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return PASSWORD_EMPTY_VALIDATION;
                                }
                                if (val.length < 6) {
                                  return PASSWORD_LENGTH_VALIDATION;
                                } else
                                  return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Error message container
                    Container(
                      child:
                          Text(errorText, style: TextStyle(color: Colors.red)),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    //Submit button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.brown[500]),
                        child: Text(
                          REGISTER_USER,
                          style: buttonStyle,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });

                            await _auth.registerWithEmailandPassword(
                              email: email.trim(),
                              password: password.trim(),
                              firstName: firstName.trim(),
                              lastName: lastName.trim(),
                              company: company.trim(),
                              phoneNumber: phoneNumber,
                              countryOfResidence: countryOfResidence,
                              cityOfResidence: cityOfResidence,
                              isActive: false,
                            );

                            setState(() {
                              loading = false;
                            });
                          }
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
