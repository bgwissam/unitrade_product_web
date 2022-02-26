import 'dart:async';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/user.dart';
import 'package:unitrade_web_v2/services/auth.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/country_drop_down.dart';
import 'package:unitrade_web_v2/shared/loading.dart';
import 'package:unitrade_web_v2/shared/string.dart';
import 'package:email_validator/email_validator.dart';

class RegisterProvider extends StatelessWidget {
  const RegisterProvider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      initialData: [],
      value: DatabaseService().userData,
      catchError: (context, err) => err,
      child: RegisterUser(),
    );
  }
}

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  List<UserData> userProvider;
  bool loading = false;
  Size _size;
  //text field state
  String firstName = '';
  String lastName = '';
  String company = '';
  String email = '';
  String confirmEmail = '';
  String phoneNumber = '';
  String nationality = '';
  String countryOfResidence = '';
  String cityOfResidence = '';
  String password = '';
  String error = '';
  String errorText = '';

  //Data controllers
  ScrollController _formScrollController = ScrollController();
  ScrollController _userListScrollController = ScrollController();
  String userId;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lasttNameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nationalityController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    userProvider = Provider.of<List<UserData>>(context);
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
            body: Row(
              children: [
                //Registering new users
                SizedBox(
                  width: _size.width / 2 - 10,
                  child: StatefulBuilder(builder: (context, setState) {
                    return SingleChildScrollView(
                      controller: _formScrollController,
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
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
                                      controller: _firstNameController,
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
                                      validator: (val) => val.isEmpty
                                          ? FIRST_NAME_VALIDATION
                                          : null,
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
                                      controller: _lasttNameController,
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
                                      validator: (val) => val.isEmpty
                                          ? LAST_NAME_VALIDATION
                                          : null,
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
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: CountryPickerDropdown(
                                          initialValue:
                                              _nationalityController.text != ''
                                                  ? _nationalityController.text
                                                  : 'SA',
                                          //show'em (the text fields) you're in charge now
                                          onTap: () => FocusScope.of(context)
                                              .requestFocus(FocusNode()),
                                          //if you want your dropdown button's selected item UI to be different
                                          //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
                                          onValuePicked: (Country country) {
                                            nationality = country.name;
                                          },
                                          itemBuilder: (Country country) {
                                            return Row(
                                              children: <Widget>[
                                                SizedBox(width: 8.0),
                                                CountryPickerUtils
                                                    .getDefaultFlagImage(
                                                        country),
                                                SizedBox(width: 8.0),
                                                Expanded(
                                                    child: Text(country.name)),
                                              ],
                                            );
                                          },
                                          itemHeight: null,
                                          isExpanded: true,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                        )),
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
                                      controller: _companyController,
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
                                        controller: _mobileController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[100],
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.blue)),
                                        ),
                                        validator: (val) {
                                          Pattern pattern =
                                              r'^(?:[05]8)?[0-9]{10}$';
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
                                      controller: _emailAddressController,
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
                            userId == null
                                ? Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(CONFIRM_EMAIL)),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey[100],
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue)),
                                            ),
                                            validator: (val) => val != email
                                                ? CONFIRM_EMAIL_MATCHING
                                                : null,
                                            onChanged: (val) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 15.0,
                            ),
                            //Password
                            userId == null
                                ? Container(
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
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue)),
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
                                  )
                                : SizedBox.shrink(),
                            //Error message container
                            Container(
                              child: Text(errorText,
                                  style: TextStyle(color: Colors.red)),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            //Submit button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //New user button
                                userId != null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.brown[500]),
                                            child: Text(
                                              NEW_USER,
                                              style: buttonStyle,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _firstNameController.text = '';
                                                _lasttNameController.text = '';
                                                _nationalityController.text =
                                                    '';
                                                _companyController.text = '';
                                                _mobileController.text = '';
                                                _emailAddressController.text =
                                                    '';
                                                userId = null;
                                              });
                                            }),
                                      )
                                    : SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.brown[500]),
                                      child: Text(
                                        userId == null
                                            ? REGISTER_USER
                                            : UPDATE_USER,
                                        style: buttonStyle,
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            loading = true;
                                          });

                                          await _auth
                                              .registerWithEmailandPassword(
                                            email: email.trim(),
                                            password: password.trim(),
                                            firstName: firstName.trim(),
                                            lastName: lastName.trim(),
                                            company: company.trim(),
                                            phoneNumber: phoneNumber,
                                            countryOfResidence:
                                                countryOfResidence,
                                            cityOfResidence: cityOfResidence,
                                            isActive: false,
                                            usersAccessList: [],
                                          );

                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                //viewing all added users
                SizedBox(
                  width: _size.width / 2 - 10,
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: SizedBox(
                          height: _size.height - 20,
                          child: ListView.builder(
                              controller: _userListScrollController,
                              itemCount: userProvider.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _firstNameController.text =
                                          userProvider[index].firstName;
                                      _lasttNameController.text =
                                          userProvider[index].lastName;
                                      _nationalityController.text =
                                          userProvider[index]
                                              .countryOfResidence;
                                      _companyController.text =
                                          userProvider[index].company;
                                      _mobileController.text =
                                          userProvider[index].phonNumber;
                                      _emailAddressController.text =
                                          userProvider[index].emailAddress;
                                      userId = userProvider[index].uid;
                                    });
                                  },
                                  child: ListTile(
                                    title: Text(
                                        '${userProvider[index].firstName} ${userProvider[index].lastName}'),
                                    subtitle: Text(
                                        'Active: ${userProvider[index].isActive} - Phone: ${userProvider[index].phonNumber}'),
                                  ),
                                );
                              }),
                        )),
                  ),
                )
              ],
            ),
          );
  }
}
