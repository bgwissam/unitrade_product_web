import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/loading.dart';

class GoogleMapLocation extends StatefulWidget {
  const GoogleMapLocation({Key key, this.roles, this.salesId})
      : super(key: key);
  final List<dynamic> roles;
  final String salesId;

  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  var apiKey = 'AIzaSyAApowjL1ZKrXhTOoieDlNzY-WUyL2V5j8';
  var lat = 0.0, long = 0.0;
  var _getMyCurrentLocation;
  var db = DatabaseService();
  PickResult selectedPlace;
  LatLng _center;
  final _elevation = 3.0;
  List<Marker> listMarkers = [];
  List<Marker> noMarkers = [];
  String clientType;
  int quoteNumber;
  //Selecting type of business
  bool factoryBusiness = true;
  bool carpentryBusiness = true;
  bool retailBusiness = true;
  bool contractorBusiness = true;
  bool fabricatorBusiness = true;
  bool kitchenRetailBusiness = true;
  // var markerId = MarkerId('one');
  Marker marker1 = Marker(
      markerId: MarkerId('No clients were loaded'),
      position: LatLng(26.3650133, 50.19190929999999),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));

  //Types of map
  List<MapType> mapType = [
    MapType.hybrid,
    MapType.satellite,
    MapType.terrain,
  ];
  MapType _mapType;
  List<String> mapTypeName = [
    'Hybrid',
    'Satellite',
    'Terrain',
  ];

  @override
  void initState() {
    super.initState();
    noMarkers.add(marker1);
    _getMyCurrentLocation = _determinePosition();
  }

  //Function will get the client markers assign by each sales depending on their previlage
  Future<List<Marker>> _getClientMarker() async {
    widget.roles.contains('isAdmin')
        ? await db.clientCollection.get().then((value) {
            return value.docs.map((elements) {
              if (elements.data()['lat'] != null &&
                  elements.data()['long'] != null &&
                  elements.data()['clientName'] != null) {
                listMarkers.add(
                  Marker(
                    markerId: MarkerId(elements.data()['clientName']),
                    position:
                        LatLng(elements.data()['lat'], elements.data()['long']),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange),
                    infoWindow: InfoWindow(
                        title: elements.data()['clientName'],
                        snippet:
                            '${elements.data()['contactName']} - ${elements.data()['clientPhone']}',
                        onTap: () {
                          _openDetailsDialog(
                              elements.data()['clientName'],
                              elements.id,
                              elements
                                  .data()['clientVisits']
                                  .reversed
                                  .toList());
                        }),
                  ),
                );
              }
            }).toList();
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
                        BitmapDescriptor.hueOrange),
                    infoWindow: InfoWindow(
                        title: elements.data()['clientName'],
                        snippet:
                            '${elements.data()['contactName']} - ${elements.data()['clientPhone']}',
                        onTap: () {
                          _openDetailsDialog(
                              elements.data()['clientName'],
                              elements.id,
                              elements
                                  .data()['clientVisits']
                                  .reversed
                                  .toList());
                        }),
                  ),
                );
              }
            }).toList();
          });
    return listMarkers;
  }

  //Client details dialog
  // ignore: missing_return
  Widget _openDetailsDialog(
      String clientName, String clientId, List<dynamic> visitList) {
    var salesId = [];
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              clientName,
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: 3 * MediaQuery.of(context).size.height / 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Visit List: ${visitList.length}',
                      style: textStyle4,
                    ),
                  ),
                  // Container(
                  //   height: 85,
                  //   child: ListView.builder(
                  //     itemCount: visitList.length,
                  //     itemBuilder: (context, index) {
                  //       return InkWell(
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (builder) => VisitDetails(
                  //                       salesVisit: salesId[index],
                  //                       roles: widget.roles)));
                  //         },
                  //         child: Card(
                  //           elevation: _elevation,
                  //           child: Center(
                  //             child: FutureBuilder(
                  //                 future: em.salesPipeline
                  //                     .doc(visitList[index])
                  //                     .get()
                  //                     .catchError((error, stackTrace) async {
                  //                   // await sentry.Sentry.captureException(error,
                  //                   //     stackTrace: stackTrace);
                  //                   throw error;
                  //                 }),
                  //                 builder: (context, snapshot) {
                  //                   if (snapshot.hasData) {
                  //                     if (snapshot.connectionState ==
                  //                         ConnectionState.done) {
                  //                       salesId.add(snapshot.data.id);
                  //                       return Container(
                  //                         padding: EdgeInsets.symmetric(
                  //                             vertical: 10.0),
                  //                         child: Text(
                  //                           snapshot.data['currentDate']
                  //                               .toDate()
                  //                               .toString()
                  //                               .split(' ')[0],
                  //                           style: textStyle1,
                  //                         ),
                  //                       );
                  //                     } else if (snapshot.connectionState ==
                  //                         ConnectionState.waiting) {
                  //                       return Container(
                  //                         child: LinearProgressIndicator(),
                  //                       );
                  //                     } else {
                  //                       return Container(
                  //                         child: Text(
                  //                             'An issue occured, visits loading failed'),
                  //                       );
                  //                     }
                  //                   } else if (snapshot.hasError) {
                  //                     return Container(
                  //                       child: Text(snapshot.error.toString()),
                  //                     );
                  //                   } else {
                  //                     return Container(
                  //                       child: LinearProgressIndicator(),
                  //                     );
                  //                   }
                  //                 }),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  //Will build the list of quotes for each client allowing you to view the quote from here
                  // Container(
                  //   height: 120,
                  //   child: FutureBuilder(
                  //     future: em.quotationCollection
                  //         .where('clientId', isEqualTo: clientId)
                  //         .get()
                  //         .then((value) => value.docs.map((e) {
                  //               return QuoteData(
                  //                 quoteId: e.data()['quoteId'],
                  //                 itemQuoted: e.data()['itemsQuoted'],
                  //                 clientName: e.data()['clientName'],
                  //                 paymentTerms: e.data()['paymentTerms'],
                  //                 status: e.data()['status'],
                  //                 pdfUrl: e.data()['pdfUrl'],
                  //                 userId: e.data()['userId'],
                  //               );
                  //             }).toList())
                  //         .catchError((error, stackTrace) async {
                  //       // await sentry.Sentry.captureException(error,
                  //       //     stackTrace: stackTrace);
                  //       throw error;
                  //     }),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         if (snapshot.connectionState ==
                  //             ConnectionState.done) {
                  //           var quoteList = snapshot.data.reversed.toList();

                  //           quoteNumber = quoteList.length;
                  //           return Column(
                  //             children: [
                  //               Container(
                  //                 padding: EdgeInsets.all(12.0),
                  //                 child: Text(
                  //                   'Quote List: ${quoteNumber.toString()}',
                  //                   style: textStyle4,
                  //                 ),
                  //               ),
                  //               Container(
                  //                 height: 75,
                  //                 child: ListView.builder(
                  //                   itemCount: quoteList.length,
                  //                   itemBuilder: (context, index) {
                  //                     Color _cardColor;
                  //                     switch (quoteList[index].status) {
                  //                       case 'WON':
                  //                         _cardColor = Colors.green;
                  //                         break;
                  //                       case 'LOST':
                  //                         _cardColor = Colors.red;
                  //                         break;
                  //                       case 'Pending':
                  //                         _cardColor = Colors.yellow;
                  //                         break;
                  //                       default:
                  //                         _cardColor = Colors.grey;
                  //                     }
                  //                     return Center(
                  //                       child: Card(
                  //                         color: _cardColor,
                  //                         elevation: _elevation,
                  //                         child: InkWell(
                  //                           onTap: () {
                  //                             Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (builder) =>
                  //                                       QuoteDetails(
                  //                                         userId:
                  //                                             quoteList[index]
                  //                                                 .userId,
                  //                                         quoteId:
                  //                                             quoteList[index]
                  //                                                 .quoteId
                  //                                                 .toString(),
                  //                                         roles: widget.roles,
                  //                                         selectedProducts:
                  //                                             quoteList[index]
                  //                                                 .itemQuoted,
                  //                                         customerName:
                  //                                             quoteList[index]
                  //                                                 .clientName,
                  //                                         paymentTerms:
                  //                                             quoteList[index]
                  //                                                 .paymentTerms,
                  //                                         status:
                  //                                             quoteList[index]
                  //                                                 .status,
                  //                                         pdfUrl:
                  //                                             quoteList[index]
                  //                                                 .pdfUrl,
                  //                                       )),
                  //                             );
                  //                           },
                  //                           child: Container(
                  //                             padding: EdgeInsets.all(12.0),
                  //                             child: Text(
                  //                                 quoteList[index]
                  //                                     .quoteId
                  //                                     .toString(),
                  //                                 style: textStyle1),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           );
                  //         } else if (snapshot.connectionState ==
                  //             ConnectionState.waiting) {
                  //           return Container(
                  //             child: LinearProgressIndicator(),
                  //           );
                  //         } else {
                  //           return Container(
                  //             child: Text(
                  //                 'An issue occured, quote loading failed'),
                  //           );
                  //         }
                  //       } else if (snapshot.hasError) {
                  //         return Container(
                  //           child: Text(snapshot.error.toString()),
                  //         );
                  //       } else {
                  //         return Container(
                  //           child: LinearProgressIndicator(),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }

  //Get the current position of the device
  //when the location service is not enabled or permissions are denied
  //the future will return an error
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Test if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service is disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //Permission are denied, try requesting persmission again
        return Future.error('Location permission are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location persmission are denied forever, we cannot handle permission requests');
    }
    //if permissions are granted
    var currentLocation = await Geolocator.getCurrentPosition();
    setState(() {
      lat = currentLocation.latitude;
      long = currentLocation.longitude;
    });
    _center = LatLng(lat, long);
    print('current Location: $currentLocation');
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Client Map'),
          backgroundColor: Colors.blueGrey,
        ),
        body: _buildLocationSelection());
  }

  Widget _buildLocationSelection() {
    print('The _center: $_center');
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: _getClientMarker(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(children: [
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 12.0),
                  markers: listMarkers.isNotEmpty
                      ? Set.of(listMarkers)
                      : Set.of(noMarkers),
                  mapType: _mapType ?? MapType.normal,
                ),
              ]);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                child: Text('${snapshot.error}'),
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Loading(),
              ),
            );
          }
        },
      ),
    );
  }
}
