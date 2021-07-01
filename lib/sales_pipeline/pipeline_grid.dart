import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/sales_pipeline/pipline_list.dart';
import 'package:unitrade_web_v2/services/database.dart';
import 'package:unitrade_web_v2/shared/string.dart';

class PipelineGrid extends StatefulWidget {
  @override
  _PipelineGridState createState() => _PipelineGridState();
}

class _PipelineGridState extends State<PipelineGrid> {
  var db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SALES_PIPELINE),
        backgroundColor: Colors.amberAccent,
      ),
      body: StreamProvider<List<SalesPipeline>>.value(
        value: db.allUsersData(),
        initialData: null,
        child: PipelineList(),
      ),
    );
  }
}
