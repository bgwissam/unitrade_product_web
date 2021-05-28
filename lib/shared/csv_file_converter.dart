import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/shared/loading.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final List<dynamic> file;
  final List<Map<String, dynamic>> mapList;

  const LoadCsvDataScreen({Key key, this.file, this.mapList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isUpdating = false;
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV Data'),
          backgroundColor: Colors.amberAccent,
          actions: [
            TextButton(
              onPressed: () async {
                _updateDataPerItemCode();
              },
              child: Text('Update Data', style: TextStyle(color: Colors.black)),
            )
          ],
        ),
        body: !_isUpdating ? _buildDataDetails() : Loading());
  }

  //Build data in the file as a Table view
  _buildDataDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: file.length,
            itemBuilder: (context, index) {
              return Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 2),
                ),
                children: [
                  TableRow(
                    children: _buildRow(file[index]),
                  ),
                ],
              );
            }),
      ),
    );
  }

  //Builds each row in the table
  List<Widget> _buildRow(List<String> currentRow) {
    var list = currentRow.map<List<Widget>>((data) {
      var widgetList = <Widget>[];
      widgetList.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(child: Text(data)),
        ),
      );

      return widgetList;
    }).toList();
    var flat = list.expand((i) => i).toList();
    return flat;
  }

  //Update stock level in the database
  _updateDataPerItemCode() async {
    String businessUnit;
    List<String> missingCodes = [];

    //loop over the maplist
    for (var row in mapList) {
      String businessLine = row['Business Line'];
      String itemCode = row['Item Code'];

      switch (businessLine) {
        case '212003':
          businessUnit = 'wood';
          break;
        case '212004':
          businessUnit = 'paint';
          break;
        case '212005':
          businessUnit = 'accessories';
          break;
        case '2120006':
          businessUnit = 'solid';
          break;
      }
      //get the item from the database
      await FirebaseFirestore.instance
          .collection(businessUnit)
          .where('itemCode', isEqualTo: itemCode)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          //Will add the codes that are missing in our database to add them later
          if (!missingCodes.contains(itemCode)) {
            missingCodes.add(itemCode);
          }
        } else {
          //_updateData(e.id, businessUnit, row['Inventory on Hand']);
          var result = value.docs.map((e) {
            return e;
          });
          result.forEach((element) {
            if (element.data().isNotEmpty || element.data() != null)
              _updateData(element.id, businessUnit,
                  int.parse(row['Inventory on Hand']));
          });
          return result;
        }
      }).onError((error, stackTrace) {
        print('An error occured with item ($itemCode): $error, $stackTrace');
        return error;
      }).catchError((error) {
        print('An error occured obtained data for item: $itemCode');
      });
    }
    print('The missing codes are: $missingCodes');
  }

  _updateData(String id, String businessUnit, int inventory) async {
    await FirebaseFirestore.instance
        .collection(businessUnit)
        .doc(id)
        .update({'inventoryOnHand': inventory})
        .whenComplete(() => print('data updated properly'))
        .onError((error, stackTrace) {
          print('Could not update data due to: $error: $stackTrace');
        });
  }
}
