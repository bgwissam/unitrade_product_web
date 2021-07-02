import 'package:flutter/material.dart';
import 'package:unitrade_web_v2/sales_pipeline/pipline_list.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class PipelineGrid extends StatefulWidget {
  const PipelineGrid({Key key, this.salesId}) : super(key: key);
  final String salesId;

  @override
  _PipelineGridState createState() => _PipelineGridState();
}

class _PipelineGridState extends State<PipelineGrid> {
  Future clientList;
  @override
  void initState() {
    super.initState();
    clientList = _buildListViewClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
      ),
      body: FutureBuilder(
        future: clientList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => PipelineList(
                              clientName: snapshot.data,
                            )));
              });
              return Center(
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else if (snapshot.hasError) {
            return Container(
              child: Text(snapshot.error),
            );
          } else {
            return Center(
                child: Container(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }

  Future _buildListViewClients() async {
    var result = await DatabaseService()
        .clientCollection
        .where('salesInCharge', isEqualTo: widget.salesId)
        .get()
        .then(
            (value) => value.docs.map((e) => e.data()['clientName']).toList());
    return result;
  }
}
