import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitrade_web_v2/models/client.dart';

class PurchasingList extends StatefulWidget {
  const PurchasingList({Key key}) : super(key: key);

  @override
  _PurchasingListState createState() => _PurchasingListState();
}

class _PurchasingListState extends State<PurchasingList> {
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          child: Text(purchases[index].clientName),
                        ),
                        //Client brand request
                        Expanded(
                            flex: 1,
                            child: Text(purchases[index].productBrand)),
                        //Client phone number
                        Expanded(
                            flex: 1,
                            child:
                                Text(purchases[index].requestDate.toString()))
                      ],
                    ),
                    //Sales data
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Client name
                        Expanded(
                            flex: 1, child: Text(purchases[index].salesId)),
                        //Client brand request
                        Expanded(
                            flex: 1, child: Text(purchases[index].orderStatus)),
                        //Client phone number
                        Expanded(
                          flex: 1,
                          child: Text(purchases[index].responseDate.toString()),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
