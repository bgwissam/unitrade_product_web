class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String company;
  final String nationality;
  final String phonNumber;
  final String emailAddress;
  final String countryOfResidence;
  final String countryCode;
  final String cityOfResidence;
  final List<dynamic> roles;
  final bool isActive;
  final String directManagerId;
  final List<dynamic> usersAccessList;

  UserData({
    this.uid,
    this.firstName,
    this.lastName,
    this.company,
    this.nationality,
    this.phonNumber,
    this.emailAddress,
    this.countryOfResidence,
    this.countryCode,
    this.cityOfResidence,
    this.roles,
    this.isActive,
    this.directManagerId,
    this.usersAccessList,
  });
}
