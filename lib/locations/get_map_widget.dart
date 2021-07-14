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

  Marker marker1 = Marker(
      markerId: MarkerId('No clients were loaded'),
      position: LatLng(26.3650133, 50.19190929999999),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Client Display'),
      ),
      body: _buildGoogleMapWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    noMarkers.add(marker1);
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

  //Navigate to details window
  Widget _openDetailsDialog(
      String clientName, String clientId, List<dynamic> visitList) {
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
    // var salesId = [];
    //when clicked return a dialog with the customer details
    // showDialog(
    //     context: context,
    //     builder: (builder) => AlertDialog(
    //           title: Text(
    //             clientName,
    //             textAlign: TextAlign.center,
    //             style: textStyle3,
    //           ),
    //           content: Center(
    //             child: Container(
    //               height: MediaQuery.of(context).size.height / 2,
    //               width: 3 * MediaQuery.of(context).size.height / 4,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   Container(
    //                     padding: EdgeInsets.all(12.0),
    //                     child: Text(
    //                       'Visit List: ${visitList.length}',
    //                       style: textStyle4,
    //                     ),
    //                   ),
    //                   Container(
    //                     height: MediaQuery.of(context).size.height / 5,
    //                     child: ListView.builder(
    //                       itemCount: visitList.length,
    //                       itemBuilder: (context, index) {
    //                         return InkWell(
    //                           onTap: () {},
    //                           child: Card(
    //                             elevation: _elevation,
    //                             child: Center(
    //                               child: FutureBuilder(
    //                                   future: db.salesPipeline
    //                                       .doc(visitList[index])
    //                                       .get()
    //                                       .catchError(
    //                                           (error, stackTrace) async {
    //                                     print(
    //                                         'An error obtaining visit items occured: $error');
    //                                     throw error;
    //                                   }),
    //                                   builder: (context, snapshot) {
    //                                     if (snapshot.hasData) {
    //                                       if (snapshot.connectionState ==
    //                                           ConnectionState.done) {
    //                                         salesId.add(snapshot.data.id);
    //                                         return Container(
    //                                           padding: EdgeInsets.symmetric(
    //                                               vertical: 10.0),
    //                                           child: Text(
    //                                             snapshot.data['currentDate']
    //                                                 .toDate()
    //                                                 .toString()
    //                                                 .split(' ')[0],
    //                                             style: textStyle1,
    //                                           ),
    //                                         );
    //                                       } else if (snapshot.connectionState ==
    //                                           ConnectionState.waiting) {
    //                                         return Container(
    //                                           child: LinearProgressIndicator(),
    //                                         );
    //                                       } else {
    //                                         return Container(
    //                                           child: Text(
    //                                               'An issue occured, visits loading failed'),
    //                                         );
    //                                       }
    //                                     } else if (snapshot.hasError) {
    //                                       return Container(
    //                                         child:
    //                                             Text(snapshot.error.toString()),
    //                                       );
    //                                     } else {
    //                                       return Container(
    //                                         child: LinearProgressIndicator(),
    //                                       );
    //                                     }
    //                                   }),
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                   //Will build the list of quotes for each client allowing you to view the quote from here
    //                   Container(
    //                     height: MediaQuery.of(context).size.height / 3,
    //                     child: FutureBuilder(
    //                       future: db.quotationCollection
    //                           .where('clientId', isEqualTo: clientId)
    //                           .get()
    //                           .then((value) => value.docs.map((e) {
    //                                 return QuoteData(
    //                                   quoteId: e.data()['quoteId'],
    //                                   itemQuoted: e.data()['itemsQuoted'],
    //                                   clientName: e.data()['clientName'],
    //                                   paymentTerms: e.data()['paymentTerms'],
    //                                   status: e.data()['status'],
    //                                   pdfUrl: e.data()['pdfUrl'],
    //                                   userId: e.data()['userId'],
    //                                 );
    //                               }).toList())
    //                           .catchError((error, stackTrace) async {
    //                         print('An error obtaining quotes occured: $error');
    //                         throw error;
    //                       }),
    //                       builder: (context, snapshot) {
    //                         if (snapshot.hasData) {
    //                           if (snapshot.connectionState ==
    //                               ConnectionState.done) {
    //                             var quoteList = snapshot.data.reversed.toList();

    //                             quoteNumber = quoteList.length;
    //                             return Column(
    //                               children: [
    //                                 Container(
    //                                   padding: EdgeInsets.all(12.0),
    //                                   child: Text(
    //                                     'Quote List: ${quoteNumber.toString()}',
    //                                     style: textStyle4,
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   height:
    //                                       MediaQuery.of(context).size.height /
    //                                           5,
    //                                   child: ListView.builder(
    //                                     itemCount: quoteList.length,
    //                                     itemBuilder: (context, index) {
    //                                       Color _cardColor;
    //                                       switch (quoteList[index].status) {
    //                                         case 'WON':
    //                                           _cardColor = Colors.green;
    //                                           break;
    //                                         case 'LOST':
    //                                           _cardColor = Colors.red;
    //                                           break;
    //                                         case 'Pending':
    //                                           _cardColor = Colors.yellow;
    //                                           break;
    //                                         default:
    //                                           _cardColor = Colors.grey;
    //                                       }
    //                                       return Center(
    //                                         child: Card(
    //                                           color: _cardColor,
    //                                           elevation: _elevation,
    //                                           child: InkWell(
    //                                             onTap: () {},
    //                                             child: Container(
    //                                               padding: EdgeInsets.all(12.0),
    //                                               child: Text(
    //                                                   quoteList[index]
    //                                                       .quoteId
    //                                                       .toString(),
    //                                                   style: textStyle1),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       );
    //                                     },
    //                                   ),
    //                                 ),
    //                               ],
    //                             );
    //                           } else if (snapshot.connectionState ==
    //                               ConnectionState.waiting) {
    //                             return Container(
    //                               child: LinearProgressIndicator(),
    //                             );
    //                           } else {
    //                             return Container(
    //                               child: Text(
    //                                   'An issue occured, quote loading failed'),
    //                             );
    //                           }
    //                         } else if (snapshot.hasError) {
    //                           return Container(
    //                             child: Text(snapshot.error.toString()),
    //                           );
    //                         } else {
    //                           return Container(
    //                             child: LinearProgressIndicator(),
    //                           );
    //                         }
    //                       },
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ));
  }

  Widget _buildGoogleMapWidget() {
    return Container(
      child: FutureBuilder(
          future: _getClientMarker(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GoogleMap(
                  mapType: MapType.satellite,
                  initialCameraPosition:
                      CameraPosition(target: widget.center, zoom: 12.0),
                  onMapCreated: (GoogleMapController _controller) {
                    _mapController = _controller;
                  },
                  mapToolbarEnabled: true,
                  gestureRecognizers: Set()
                    ..add(Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer()))
                    ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()))
                    ..add(Factory<HorizontalDragGestureRecognizer>(
                        () => HorizontalDragGestureRecognizer()))
                    ..add(Factory<ScaleGestureRecognizer>(
                        () => ScaleGestureRecognizer())),
                  markers: listMarkers.isNotEmpty
                      ? Set.of(listMarkers)
                      : Set.of(noMarkers),
                );
              } else {
                return Center(
                  child: Container(
                    child: Loading(),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: Loading(),
                ),
              );
            }
          }),
    );
  }
}
