import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitrade_web_v2/locations/client_details.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/loading.dart';

class GoogleMapClientLocation extends StatefulWidget {
  final LatLng center;
  final List<dynamic> roles;
  final String salesId;
  const GoogleMapClientLocation(
      {Key key, this.center, this.roles, this.salesId})
      : super(key: key);
  @override
  _GoogleMapClientLocationState createState() =>
      _GoogleMapClientLocationState();
}

class _GoogleMapClientLocationState extends State<GoogleMapClientLocation> {
  GoogleMapController _mapController;
  var allCients = Clients();
  final _elevation = 3.0;
  List<Marker> listMarkers = [];
  List<Marker> noMarkers = [];
  DatabaseService db = DatabaseService();
  int quoteNumber;
  int counter = 0;
  bool _isListReady = false;
  Marker marker1 = Marker(
      markerId: MarkerId('No clients were loaded'),
      position: LatLng(26.3650133, 50.19190929999999),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Google Map Client Display - Clients: ${listMarkers.length}'),
      ),
      body: _buildGoogleMapWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    //_getClientMarker();
    noMarkers.add(marker1);
  }

  //Function will get the client markers assign by each sales depending on their previlage
  Future<List<Marker>> _getClientMarker() async {
    List<dynamic> showroom;
    var kitchenColor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(40, 40)),
            'assets/images/markers/marker.jpg')
        .then((value) => value);
    widget.roles.contains('isAdmin')
        ? await db.clientCollection.get().then((value) async {
            return value.docs.map((elements) async {
              if (elements.data()['lat'] != null &&
                  elements.data()['long'] != null &&
                  elements.data()['clientName'] != null) {
                if (elements.data()['clientSector'] == 'Fabricator') {
                  showroom = await db.clientCollection
                      .doc(elements.id)
                      .collection('showrooms')
                      .get()
                      .then((value) {
                    return value.docs.map((e) {
                      return e.data()['showrooms'];
                    }).toList();
                  }).catchError((err) {
                    print('An error occured: $err');
                  });
                  // print('the clients 1: ${listMarkers.length}');
                  if (showroom != null && showroom.isNotEmpty) {
                    for (var chain in showroom) {
                      for (var room in chain) {
                        listMarkers.add(
                          Marker(
                            markerId: MarkerId(room['name']),
                            position: LatLng(room['lat'], room['long']),
                            icon: kitchenColor,
                            infoWindow: InfoWindow(
                              title: room['name'],
                              snippet: 'nothing now',
                              onTap: () {
                                _openDetailsDialog(
                                    clientName: room['name'],
                                    images: room['imageUrls']);
                              },
                            ),
                          ),
                        );

                        // print(
                        //     'room: ${room['name']} - ${room['lat']} - ${room['long']} - ${listMarkers.length}');
                      }
                    }
                  }
                } else {
                  //print('the clients 2: ${listMarkers.length}');
                  listMarkers.add(
                    Marker(
                      markerId: MarkerId(elements.data()['clientName']),
                      position: LatLng(
                          elements.data()['lat'], elements.data()['long']),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      infoWindow: InfoWindow(
                          title: elements.data()['clientName'],
                          snippet:
                              '${elements.data()['contactName']} - ${elements.data()['clientPhone']}',
                          onTap: () {
                            _openDetailsDialog(
                                clientName: elements.data()['clientName'],
                                clientId: elements.id,
                                visitList: elements
                                    .data()['clientVisits']
                                    .reversed
                                    .toList());
                          }),
                    ),
                  );
                }
              }
            }).toList();
          }).catchError((err) {
            print('An error occured: $err');
          })
        : await db.clientCollection
            .where('salesInCharge', isEqualTo: widget.salesId)
            .get()
            .then((value) {
            return value.docs.map((elements) {
              if (elements.data()['lat'] != null &&
                  elements.data()['long'] != null) {
                listMarkers.add(
                  Marker(
                    markerId: MarkerId(elements.data()['clientName']),
                    position:
                        LatLng(elements.data()['lat'], elements.data()['long']),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    infoWindow: InfoWindow(
                        title: elements.data()['clientName'],
                        snippet:
                            '${elements.data()['contactName']} - ${elements.data()['clientPhone']}',
                        onTap: () {
                          _openDetailsDialog(
                              clientName: elements.data()['clientName'],
                              clientId: elements.id,
                              visitList: elements
                                  .data()['clientVisits']
                                  .reversed
                                  .toList());
                        }),
                  ),
                );
              }
            }).toList();
          });
    print(listMarkers.length);

    return listMarkers;
  }

  _getMarkersStream() {
    //stream data
    return db.clientCollection.where('lat', isNotEqualTo: null).snapshots();
  }

  //Navigate to details window
  void _openDetailsDialog(
      {String clientName,
      String clientId,
      List<dynamic> visitList,
      List<dynamic> images}) {
    if (clientName != null && clientId != null && visitList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => ClientDetails(
                  clientId: clientId,
                  clientName: clientName,
                  visitList: visitList,
                )),
      );
    } else if (images != null && images.isNotEmpty) {
      print('the images here will be displayed');
    } else {
      showDialog(
        context: context,
        builder: (builder) => AlertDialog(
          title: Text('Missing variables'),
          content: Text(
              'Some data is missing for this client, please check with administrator before proceeding'),
        ),
      );
    }
  }

  _getGoogleLocationMarkers(var client) {
    for (var i = 0; i < client.length; i++) {
      print('the client: ${client[i]['clientName']}');
      if (client[i]['lat'] != null) {
        listMarkers.add(
          Marker(
            markerId: MarkerId(client[i]['clientName']),
            position: LatLng(client[i]['lat'], client[i]['long']),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: client[i]['clientName'],
              snippet:
                  '${client[i]['contactName']} - ${client[i]['clientPhone']}',
              onTap: () {
                _openDetailsDialog(
                    clientName: client[i]['clientName'],
                    clientId: client[i].id,
                    visitList: client[i]['clientVisits'].reversed.toList());
              },
            ),
          ),
        );
      }
    }
  }

  Widget _buildGoogleMapWidget() {
    return StreamBuilder<QuerySnapshot>(
        stream: _getMarkersStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data.containsKey('lat')) {
            if (snapshot.data.docs != null) {
              _getGoogleLocationMarkers(snapshot.data.docs);
            }
            return GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition:
                  CameraPosition(target: widget.center, zoom: 12.0),
              onMapCreated: (GoogleMapController _controller) {
                _mapController = _controller;
              },
              mapToolbarEnabled: true,
              gestureRecognizers: Set()
                ..add(
                    Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()))
                ..add(Factory<HorizontalDragGestureRecognizer>(
                    () => HorizontalDragGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer())),
              markers: Set.of(listMarkers),

              // listMarkers.isNotEmpty
              //     ? Set.of(listMarkers)
              //     : Set.of(noMarkers),
            );
          } else {
            return Center(
              child: Container(
                child: Text('No data obtained'),
              ),
            );
          }
        });

    //   FutureBuilder(
    //       future: _getClientMarker(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           print('the clients: ${snapshot.data.length}');
    //           if (snapshot.connectionState == ConnectionState.done) {
    //             return GoogleMap(
    //               mapType: MapType.satellite,
    //               initialCameraPosition:
    //                   CameraPosition(target: widget.center, zoom: 12.0),
    //               onMapCreated: (GoogleMapController _controller) {
    //                 _mapController = _controller;
    //               },
    //               mapToolbarEnabled: true,
    //               gestureRecognizers: Set()
    //                 ..add(Factory<PanGestureRecognizer>(
    //                     () => PanGestureRecognizer()))
    //                 ..add(Factory<VerticalDragGestureRecognizer>(
    //                     () => VerticalDragGestureRecognizer()))
    //                 ..add(Factory<HorizontalDragGestureRecognizer>(
    //                     () => HorizontalDragGestureRecognizer()))
    //                 ..add(Factory<ScaleGestureRecognizer>(
    //                     () => ScaleGestureRecognizer())),
    //               markers: listMarkers.isNotEmpty
    //                   ? Set.of(listMarkers)
    //                   : Set.of(noMarkers),
    //             );
    //           } else {
    //             return Center(
    //               child: Container(
    //                 child: Loading(),
    //               ),
    //             );
    //           }
    //         } else if (snapshot.hasError) {
    //           return Center(
    //             child: Container(
    //               child: Text(snapshot.error.toString()),
    //             ),
    //           );
    //         } else {
    //           return Center(
    //             child: Container(
    //               child: Loading(),
    //             ),
    //           );
    //         }
    //       }),
    // );
  }
}
