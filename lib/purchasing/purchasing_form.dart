import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unitrade_web_v2/models/client.dart';
import 'package:unitrade_web_v2/shared/constants.dart';

class PurchasingForm extends StatefulWidget {
  const PurchasingForm({Key key, this.purchaseModel, this.salesName})
      : super(key: key);
  final PurchaseModel purchaseModel;
  final String salesName;

  @override
  State<PurchasingForm> createState() => _PurchasingFormState();
}

class _PurchasingFormState extends State<PurchasingForm> {
  final _formKey = GlobalKey<FormState>();
  Size _size;
  RegExp regExp = new RegExp(r'^[a-zA-Z]');
  List<double> cost;
  List<double> price;
  List<double> margin;
  List<String> leadTime;

  @override
  void initState() {
    cost = List.generate(
        widget.purchaseModel.itemsRequested.length, (index) => 0.0);
    price = List.generate(
        widget.purchaseModel.itemsRequested.length, (index) => 0.0);
    margin = List.generate(
        widget.purchaseModel.itemsRequested.length, (index) => 0.0);
    leadTime = List.generate(
        widget.purchaseModel.itemsRequested.length, (index) => '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Purhcase Request for ${widget.purchaseModel.clientName}'),
        backgroundColor: Colors.amberAccent,
        actions: [
          //save button to update database
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {}
              },
              child: Text(
                'Save',
                style: textStyle7,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: _buildPurchaseForm(),
      ),
    );
  }

  Widget _buildPurchaseForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: SizedBox(
          height: _size.height,
          child: Column(
            children: [
              //Client name
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Client Name: '),
                  Text(widget.purchaseModel.clientName.toString(),
                      style: textStyle8)
                ],
              ),
              //sales man name
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Sales Name: '),
                  Text(widget.salesName.toString(), style: textStyle8)
                ],
              ),
              //Product brand
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Brand Name: '),
                  Text(
                    widget.purchaseModel.productBrand.toString(),
                    style: textStyle8,
                  )
                ],
              ),
              //List of items requested
              SizedBox(
                height: _size.height / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'Items Requested',
                        style: textStyle3,
                      ),
                    ),
                    SizedBox(
                      height: widget.purchaseModel.itemsRequested.length * 200,
                      width: _size.width - 100,
                      child: ListView.builder(
                          itemCount: widget.purchaseModel.itemsRequested.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //filled data by sales man
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          //Description
                                          Text(
                                              'Description: ${widget.purchaseModel.itemsRequested[index]['description']}'),
                                          //Item code
                                          Text(
                                              'Code: ${widget.purchaseModel.itemsRequested[index]['itemCode']}'),
                                          //Packing
                                          Text(
                                              'Pack: ${widget.purchaseModel.itemsRequested[index]['packing']}'),
                                          //Quantity
                                          Text(
                                              'Quantity: ${widget.purchaseModel.itemsRequested[index]['quantity']}'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          //Cost
                                          Container(
                                            width: _size.width / 4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: TextFormField(
                                                style: textStyle8,
                                                initialValue: '',
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .deny(regExp)
                                                ],
                                                decoration: InputDecoration(
                                                  suffix: Text('SAR'),
                                                  filled: true,
                                                  hintText: 'Cost of item',
                                                  fillColor: Colors.grey[100],
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                ),
                                                onChanged: (val) {
                                                  if (val.isNotEmpty) {
                                                    cost[index] =
                                                        double.parse(val);
                                                    if (price[index] != 0.0 &&
                                                        cost[index] != 0.0) {
                                                      setState(() {
                                                        margin[index] = ((price[
                                                                        index] -
                                                                    cost[
                                                                        index]) /
                                                                cost[index]) *
                                                            100;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        margin[index] = 0.0;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      margin[index] = 0.0;
                                                    });
                                                  }
                                                }),
                                          ),
                                          //Price
                                          Container(
                                            width: _size.width / 4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: TextFormField(
                                                style: textStyle8,
                                                initialValue: '',
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .deny(regExp)
                                                ],
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  suffix: Text('SAR'),
                                                  hintText: 'Price of item',
                                                  fillColor: Colors.grey[100],
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                ),
                                                onChanged: (val) {
                                                  if (val.isNotEmpty) {
                                                    price[index] =
                                                        double.parse(val);
                                                    if (price[index] != 0.0 &&
                                                        cost[index] != 0.0) {
                                                      setState(() {
                                                        margin[index] = ((price[
                                                                        index] -
                                                                    cost[
                                                                        index]) /
                                                                cost[index]) *
                                                            100;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        margin[index] = 0.0;
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      margin[index] = 0.0;
                                                    });
                                                  }
                                                }),
                                          ),
                                          //Lead time
                                          Container(
                                            width: _size.width / 4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: TextFormField(
                                                initialValue: '',
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  hintText: 'Lead time of item',
                                                  fillColor: Colors.grey[100],
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                ),
                                                onChanged: (val) {
                                                  if (val.isNotEmpty) {
                                                    leadTime[index] = val;
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 25),
                                      child: Text(
                                        'Margin: ${margin[index].toStringAsFixed(2)}%',
                                        style: textStyle8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
