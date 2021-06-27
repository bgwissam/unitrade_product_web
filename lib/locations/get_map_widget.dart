// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// import 'dart:ui' as ui;

// Widget getMap() {
//   String htmlId = '7';
//   // ignore: undefined_prefixed_name
//   ui.plaformViewRegistry.registerViewFactory(htmlId, (int viewId) {
//     final myLatLang = LatLng(55.0, 86.0);
//     final mapOptions = MapOptions()
//       ..zoom = 4
//       ..center = LatLng(55.0, 86.0);

//     final element = DivElement()
//       ..id = htmlId
//       ..style.width = '100%'
//       ..style.height = '100%'
//       ..style.border = 'none';

//     final map = GMap(element, mapOptions);

//     Marker(MarkerOptions()
//       ..position = myLatLang
//       ..map = map
//       ..title = 'Client Map');

//     return element;
//   });

//   return HtmlElementView(viewType: htmlId);
// }
