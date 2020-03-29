//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:financed/services/networking.dart';

class DataDisplayScreen extends StatefulWidget {
  DataDisplayScreen({this.txtFldEntry});
  final txtFldEntry;

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  String companyName = '';
  String stockSymbol = '';
  String dateDCF = '';
  double stockPrice = 0;
  double stockDCF = 0;

  @override
  void initState() {
    super.initState();
    updateBasicDataUI(widget.txtFldEntry);
  }

  dynamic getBasicData(String txtFldEntry) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://financialmodelingprep.com/api/v3/quote/$txtFldEntry');
    var stockBasicData = await networkHelper.getData();
    return stockBasicData;
  }

  dynamic getDCF(String txtFldEntry) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://financialmodelingprep.com/api/v3/company/discounted-cash-flow/$txtFldEntry');
    var stockDCF = await networkHelper.getData();
    return stockDCF;
  }

  void updateBasicDataUI(dynamic txtFldEntry) async {
    var basicStockData = await getBasicData(txtFldEntry);
    var stockDCFData = await getDCF(txtFldEntry);
    setState(() {
      //update UI stock basic data
      if (basicStockData == null) {
        stockPrice = 0;
        stockSymbol = basicStockData[0][''];
        companyName = basicStockData[0][''];
        return;
      }
      try {
        stockPrice = basicStockData[0]['price'];
        stockSymbol = basicStockData[0]['symbol'];
        companyName = basicStockData[0]['name'];
      } catch (e) {
        print(e);
      }
      //update UI stock DCF value
      if (stockDCFData == null) {
        stockDCF = 0;
        return;
      }
      try {
        //stockDCF = stockDCFData['dcf'];
        stockDCF = double.parse(stockDCFData['dcf'].toStringAsFixed(2));
        dateDCF = stockDCFData['date'];
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Company: $companyName'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Symbol: $stockSymbol'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Price: \$$stockPrice'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Instrinsic Value (DCF): \$$stockDCF'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Date: $dateDCF'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//      body: Center(
//        child: Text(
//          'Stock price: $stockPrice',
//        ),
//      ),
