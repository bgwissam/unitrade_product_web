import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

class CountryDropDownPicker extends StatefulWidget {
  final String countryOfResidence;
  CountryDropDownPicker({this.countryOfResidence});
  @override
  _CountryDropDownPickerState createState() => _CountryDropDownPickerState();
}

class _CountryDropDownPickerState extends State<CountryDropDownPicker> {
  String newCountryOfResidence;
  Country country;

  @override
  Widget build(BuildContext context) {
    return CountryPickerDropdown(
      initialValue:
          widget.countryOfResidence == '' ? 'SA' : widget.countryOfResidence,
      //show'em (the text fields) you're in charge now
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      //if you want your dropdown button's selected item UI to be different
      //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
      onValuePicked: (Country country) {
        newCountryOfResidence = country.name;
      },
      itemBuilder: (Country country) {
        return Row(
          children: <Widget>[
            SizedBox(width: 8.0),
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Expanded(child: Text(country.name)),
          ],
        );
      },
      itemHeight: null,
      isExpanded: true,
      //initialValue: 'TR',
      icon: Icon(Icons.keyboard_arrow_down),
    );
  }
}
