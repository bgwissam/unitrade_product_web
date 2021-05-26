import 'package:flutter/material.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final List<dynamic> file;
  final List<Map<String, dynamic>> mapList;

  const LoadCsvDataScreen({Key key, this.file, this.mapList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('The map list: ${mapList[0]}');
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV Data'),
          backgroundColor: Colors.amberAccent,
        ),
        body: _buildDataDetails());
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
}
