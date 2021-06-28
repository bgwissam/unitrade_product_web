import 'package:flutter/material.dart';
import "package:google_maps_webservice/geocoding.dart";
import "package:google_maps_webservice/places.dart";
import 'package:google_maps_webservice/staticmap.dart';

import 'package:unitrade_web_v2/shared/loading.dart';

class GoogleMapLocation extends StatefulWidget {
  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  var apiKey = 'AIzaSyAApowjL1ZKrXhTOoieDlNzY-WUyL2V5j8';
  var lat = 0.0, long = 0.0;
  var _getMyCurrentLocation;
  var staticMap;
  var imgUrl;

  @override
  void initState() {
    super.initState();
    staticMap = StaticMap(apiKey,
        markers: List.from([
          Location(lat: 23.721160, lng: 90.394435),
          Location(lat: 23.732322, lng: 90.385142),
        ]),
        path: Path(
          enc: 'svh~F`j}uOusC`bD',
          color: 'black',
        ),
        scale: false);
  }

  @override
  Widget build(BuildContext context) {
    imgUrl = staticMap.getUrl();

    return Scaffold(
        appBar: AppBar(
          title: Text('Client Map'),
          backgroundColor: Colors.blueGrey,
        ),
        body: _buildLocationSelection());
  }

  Widget _buildLocationSelection() {
    return Container(
      child: Image.network(imgUrl),
    );
  }
}
