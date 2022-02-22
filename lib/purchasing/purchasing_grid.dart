import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/purchasing/purchasing_list.dart';
import 'package:unitrade_web_v2/services/database.dart';

class PurchasingGrid extends StatelessWidget {
  PurchasingGrid({Key key}) : super(key: key);
  final DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PurchaseModel>>.value(
      value: db.getAllPurchaseRequests(),
      initialData: [],
      catchError: (context, err) => err,
      child: PurchasingList(),
    );
  }
}
