import 'dart:html';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unitrade_web_v2/shared/loading.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final File file;

  const LoadCsvDataScreen({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Data'),
        backgroundColor: Colors.amberAccent,
      ),
      body: FutureBuilder(
        future: loadingCsvData(file),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: snapshot.data.map((data) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(data[0].toString()),
                        Text(data[1].toString()),
                        Text(data[2].toString())
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: EdgeInsets.all(25.0),
              child: Container(
                child: Text('An Error occured: ${snapshot.error}'),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text('Please wait...'),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  child: Loading(),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<List<dynamic>>> loadingCsvData(File file) async {
    //return CsvToListConverter().convert(file);
  }
}
