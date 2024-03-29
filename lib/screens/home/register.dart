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
import 'package:unitrade_web_v2/shared/dropdownLists.dart';
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
  final DatabaseService db = DatabaseService();
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
  String nationalityCode = '';
  String countryOfResidence = '';
  String cityOfResidence = '';
  String password = '';
  String error = '';
  String errorText = '';
  List<dynamic> roles = [];
  String selectedRole;
  bool isActive;
  UserData _selectedUser;

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

  List<String> _rolesList = RolesList.roles();

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
                                            nationalityCode = country.isoCode;
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
                                        enabled: _selectedUser == null
                                            ? true
                                            : false,
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
                            //roles and user list and active and not active
                            Divider(
                              height: 40,
                              thickness: 3,
                            ),
                            //list of roles
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(ROLES),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 55,
                                        child: DropdownButtonHideUnderline(
                                            child:
                                                DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          value: selectedRole,
                                          isExpanded: true,
                                          isDense: false,
                                          hint: Center(
                                            child: Text('Select user roles'),
                                          ),
                                          onChanged: (String val) {
                                            setState(() {
                                              if (!roles.contains(val)) {
                                                roles.add(val);
                                              }

                                              selectedRole = val;
                                            });
                                          },
                                          selectedItemBuilder:
                                              (BuildContext context) {
                                            return _rolesList
                                                .map<Widget>(
                                                  (item) => Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      item,
                                                      style: textStyle8,
                                                    ),
                                                  ),
                                                )
                                                .toList();
                                          },
                                          validator: (val) => roles.isEmpty
                                              ? 'At least one role should be assigned'
                                              : null,
                                          items: _rolesList
                                              .map(
                                                (item) =>
                                                    DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Center(
                                                    child: Text(item),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            roles.isEmpty
                                ? SizedBox.shrink()
                                : Container(
                                    height: 55,
                                    child: ListView.builder(
                                        itemCount: roles.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (roles.isNotEmpty) {
                                                    roles.removeAt(index);
                                                  }
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  roles[index].toString(),
                                                  style: textStyle8,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

                            //is active user or not
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(ROLES),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 50,
                                        child: DropdownButtonHideUnderline(
                                            child:
                                                DropdownButtonFormField<bool>(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          value: _selectedUser == null
                                              ? isActive
                                              : _selectedUser.isActive,
                                          isExpanded: true,
                                          isDense: true,
                                          hint: Center(
                                            child: Text('Activate User'),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              _selectedUser == null
                                                  ? isActive = val
                                                  : isActive =
                                                      _selectedUser.isActive;
                                            });
                                          },
                                          selectedItemBuilder:
                                              (BuildContext context) {
                                            return [true, false]
                                                .map<Widget>(
                                                  (item) => Center(
                                                    child: Text(
                                                      item.toString(),
                                                      style: textStyle8,
                                                    ),
                                                  ),
                                                )
                                                .toList();
                                          },
                                          validator: (val) {
                                            if (isActive == null &&
                                                _selectedUser.isActive ==
                                                    null) {
                                              return 'Chose if you want to activate account';
                                            }
                                            return null;
                                          },
                                          items: [true, false]
                                              .map(
                                                (item) =>
                                                    DropdownMenuItem<bool>(
                                                  value: item,
                                                  child: Center(
                                                    child:
                                                        Text(item.toString()),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Divider(
                              height: 40,
                              thickness: 3,
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
                                                _selectedUser = null;
                                                roles = [];
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
                                          if (userId == null) {
                                            await _auth
                                                .registerWithEmailandPassword(
                                              email: email.trim(),
                                              password: password.trim(),
                                              firstName: firstName.trim(),
                                              lastName: lastName.trim(),
                                              company: company.trim(),
                                              phoneNumber: phoneNumber,
                                              countryOfResidence: nationality,
                                              countryCode: nationalityCode,
                                              cityOfResidence: cityOfResidence,
                                              roles: roles,
                                              isActive: isActive,
                                              usersAccessList: [],
                                            );
                                            if (mounted) {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          } else {
                                            await db.setUserData(
                                              uid: userId,
                                              firstName:
                                                  _firstNameController.text,
                                              lastName:
                                                  _lasttNameController.text,
                                              company: _companyController.text,
                                              phoneNumber:
                                                  _mobileController.text,
                                              countryOfResidence:
                                                  _nationalityController.text,
                                              countryCode: nationalityCode ??
                                                  _selectedUser.countryCode,
                                              isActive: isActive ??
                                                  _selectedUser.isActive,
                                              roles: roles.isEmpty
                                                  ? _selectedUser.roles
                                                  : roles,
                                              emailAddress:
                                                  _selectedUser.emailAddress,
                                            );
                                            if (mounted) {
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          }
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
                                          userProvider[index].countryCode;
                                      _companyController.text =
                                          userProvider[index].company;
                                      _mobileController.text =
                                          userProvider[index].phonNumber;
                                      _emailAddressController.text =
                                          userProvider[index].emailAddress;
                                      roles = userProvider[index].roles;

                                      userId = userProvider[index].uid;
                                      _selectedUser = userProvider[index];
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lasttNameController.dispose();
    _emailAddressController.dispose();
    _nationalityController.dispose();
    _companyController.dispose();
    _mobileController.dispose();
    _formScrollController.dispose();
    _userListScrollController.dispose();

    super.dispose();
  }
}
