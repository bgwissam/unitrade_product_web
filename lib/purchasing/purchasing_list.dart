import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:intl/intl.dart';
import 'package:unitrade_web_v2/purchasing/purchasing_form.dart';
import 'package:unitrade_web_v2/services/database.dart';

class PurchasingList extends StatefulWidget {
  const PurchasingList({Key key}) : super(key: key);

  @override
  _PurchasingListState createState() => _PurchasingListState();
}

class _PurchasingListState extends State<PurchasingList> {
  DatabaseService db = DatabaseService();
  List<PurchaseModel> purchases;

  Size _size;
  @override
  Widget build(BuildContext context) {
    purchases = Provider.of<List<PurchaseModel>>(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Reuqests'),
        backgroundColor: Colors.amberAccent,
      ),
      body: _buildPurhaseList(),
    );
  }

  Widget _buildPurhaseList() {
    return SingleChildScrollView(
      child: SizedBox(
        height: _size.height,
        child: ListView.builder(
          itemCount: purchases.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
                future: _getSalesName(purchases[index].salesId),
                builder: (context, snapshot) {
                  return InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PurchasingForm(
                            purchaseModel: purchases[index],
                            salesName: snapshot.data,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[200]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //Client data
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //Client name
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      'Client: ${purchases[index].clientName}'),
                                ),
                                //Client brand request
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                        'Brand: ${purchases[index].productBrand}')),
                                //Client request date
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Requested On: ${DateFormat().add_yMMMd().format(purchases[index].requestDate.toDate())}',
                                  ),
                                )
                              ],
                            ),
                            //Sales data
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //sales name
                                Expanded(
                                  flex: 1,
                                  child: Text('Sales person: ${snapshot.data}'),
                                ),
                                //order status
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                        'Status: ${purchases[index].orderStatus}')),
                                //Client phone number
                                purchases[index].responseDate != null
                                    ? Expanded(
                                        flex: 1,
                                        child: Text(
                                            'Responsed On: ${DateFormat().add_yMMMd().format(purchases[index].responseDate.toDate())}'),
                                      )
                                    : Expanded(
                                        flex: 1,
                                        child: Text('Responsed On: TBA'),
                                      )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Future<String> _getSalesName(String userId) async {
    return await db.getUserById(userId);
  }
}
