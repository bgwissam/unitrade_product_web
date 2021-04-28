import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/brands/brand_form.dart';
import 'package:unitrade_web_v2/models/brand.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/constants.dart';
import 'package:unitrade_web_v2/shared/loading.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class BrandGrid extends StatefulWidget {
  final List<dynamic> roles;

  const BrandGrid({Key key, this.roles}) : super(key: key);

  @override
  _BrandGridState createState() => _BrandGridState();
}

class _BrandGridState extends State<BrandGrid> {
  List<Brand> currentBrands = [];
  DatabaseService db = new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BRAND_GRID),
        backgroundColor: Colors.amberAccent,
      ),
      body: _buildBrandGrid(),
    );
  }
  
  _getBrands() async {
  currentBrands = [];
  currentBrands = await db.getAllBrands();

  return currentBrands;
 }

  Widget _buildBrandGrid() {
    return FutureBuilder(
      future: _getBrands(),
      builder: (context,  snapshot) {
        if(snapshot.hasData) {
          if(snapshot.connectionState == ConnectionState.done) {
           return Center(
             child: Container(
               width: MediaQuery.of(context).size.width/3,
               child: ListView.builder(
                 itemCount: currentBrands.length,
                 itemBuilder: (context, index) {
                   return Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: InkWell(
                       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BrandForm(roles: widget.roles, brand: currentBrands[index]))),
                       child: Container(
                         height: 50,
                         width: 100,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(),
                           color: Colors.deepOrange[500]
                         ),
                         child: Center(child: Text(currentBrands[index].brandName, textAlign: TextAlign.center, style: textStyle1,)),
                       ),
                     ),
                   );
               }),
             ),
           );
           
          } else if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          } else {
            return Center(child: Container(child: Text('No Data available'),));
          }
        } else if(snapshot.hasError) {
          return Container(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return Center(child: Container(child: Text('Please wait...')));
        }
      });
  }
}