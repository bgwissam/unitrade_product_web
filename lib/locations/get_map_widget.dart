import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitrade_web_v2/locations/client_details.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/image_carousal.dart';
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
  var kitchenColor;
  var factoryColor;
  var fabricatorColor;
  var carpentryColor;
  var retailColor;
  var contractorColor;
  String clientSector;
  bool _isListReady = false;
  Marker marker1 = Marker(
      markerId: MarkerId('No clients were loaded'),
      position: LatLng(26.3650133, 50.19190929999999),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Google Map Client Display - Clients: ${listMarkers.length}'),
            SizedBox(
              height: 120,
              width: size.width / 2,
              child: Row(
                children: [
                  //Kitchen Dealers
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clientSector = 'Kitchen Retail';
                        listMarkers.clear();
                        _getClientMarkers();
                        _getShowroomMarkers();
                      });
                    },
                    child: SizedBox(
                      width: size.width / 10,
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/images/markers/blue.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          'Kitchen',
                          style: textStyle7,
                        ),
                      ),
                    ),
                  ),
                  //Factories
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clientSector = 'Factory';
                        listMarkers.clear();
                        _getClientMarkers();
                      });
                    },
                    child: SizedBox(
                      width: size.width / 10,
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/images/markers/red.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          'Factory',
                          style: textStyle7,
                        ),
                      ),
                    ),
                  ),
                  //Carpentries
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clientSector = 'Carpentry';
                        listMarkers.clear();
                        _getClientMarkers();
                      });
                    },
                    child: SizedBox(
                      width: size.width / 10,
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  'assets/images/markers/yellow.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          'Carpenty',
                          style: textStyle7,
                        ),
                      ),
                    ),
                  ),
                  //Fabricators
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clientSector = 'Fabricator';
                        listMarkers.clear();
                        _getClientMarkers();
                      });
                    },
                    child: SizedBox(
                      width: size.width / 10,
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/images/markers/green.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          'Fabricator',
                          style: textStyle7,
                        ),
                      ),
                    ),
                  ),
                  //Retails
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clientSector = 'Retail';
                        listMarkers.clear();
                        _getClientMarkers();
                      });
                    },
                    child: SizedBox(
                      width: size.width / 10,
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                  'assets/images/markers/purple.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          'Retail',
                          style: textStyle7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _buildGoogleMapWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    _assignMarkerColors();
    _getClientMarkers();
    _getShowroomMarkers();
    noMarkers.add(marker1);
  }

  Future<void> _assignMarkerColors() async {
    kitchenColor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 30)),
            'assets/images/markers/blue.jpg')
        .then((value) => value);
    factoryColor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 30)),
            'assets/images/markers/red.jpg')
        .then((value) => value);
    fabricatorColor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 30)),
            'assets/images/markers/green.jpg')
        .then((value) => value);

    carpentryColor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 30)),
            'assets/images/markers/yellow.jpg')
        .then((value) => value);

    retailColor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(15, 30)),
            'assets/images/markers/purple.jpg')
        .then((value) => value);
  }

  _setMarkerColor(String clientSector) {
    if (clientSector == 'Fabricator') {
      return fabricatorColor;
    }
    if (clientSector == 'Carpentry') {
      return carpentryColor;
    }
    if (clientSector == 'Retail') {
      return retailColor;
    }
    if (clientSector == 'Factory') {
      return factoryColor;
    }
    return kitchenColor;
  }

  //Function will get the client markers assign by each sales depending on their previlage
  Future<List<Marker>> _getClientMarkers() async {
    print('the client sector: $clientSector');
    widget.roles.contains('isAdmin')
        ? await db.clientCollection
            .where('clientSector', isEqualTo: clientSector)
            .get()
            .then((value) async {
            return value.docs.map((elements) async {
              if (elements.data()['lat'] != null &&
                  elements.data()['long'] != null &&
                  elements.data()['clientName'] != null) {
                var color = _setMarkerColor(elements.data()['clientSector']);
                setState(() {
                  listMarkers.add(
                    Marker(
                      markerId: MarkerId(elements.data()['clientName']),
                      position: LatLng(
                          elements.data()['lat'], elements.data()['long']),
                      icon: color,
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
                });
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

  Future<void> _getShowroomMarkers() async {
    List<dynamic> showroom;

    await db.clientCollection.get().then((value) async {
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
                  setState(() {
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
                  });
                }
              }
            }
          }
        }
      }).toList();
    }).catchError((err) {
      print('An error occured: $err');
    });
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => ImageCarousalView(images),
        ),
      );
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
    print('List Markers: ${listMarkers.length}');
    if (listMarkers.isNotEmpty) {
      return GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition:
            CameraPosition(target: widget.center, zoom: 12.0),
        onMapCreated: (GoogleMapController _controller) {
          _mapController = _controller;
        },
        mapToolbarEnabled: true,
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()))
          ..add(Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer()))
          ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
        markers: Set.of(listMarkers),
      );
    } else {
      return GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition:
            CameraPosition(target: widget.center, zoom: 12.0),
        onMapCreated: (GoogleMapController _controller) {
          _mapController = _controller;
        },
        mapToolbarEnabled: true,
        gestureRecognizers: Set()
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer()))
          ..add(Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer()))
          ..add(
              Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
        markers: Set.of(noMarkers),
      );
    }
  }

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
