import 'package:flutter/material.dart';

class LoadCsvDataScreen extends StatelessWidget {
  final List<dynamic> file;

  const LoadCsvDataScreen({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('CSV Data'),
          backgroundColor: Colors.amberAccent,
        ),
        body: _buildDataDetails());
  }

  //Build data in the file as a Table view
  _buildDataDetails() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: file.length,
          itemBuilder: (context, index) {
            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(width: 1.0),
              children: [
                TableRow(
                  children: _buildRow(file[index]),
                ),
              ],
            );
          }),
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
