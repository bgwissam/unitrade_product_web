import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as uiMap;

import 'package:unitrade_web_v2/locations/get_map_widget.dart';

class GoogleMapLocation extends StatefulWidget {
  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Client Map'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container());
  }
}
