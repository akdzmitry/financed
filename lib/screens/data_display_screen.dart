//import 'dart:html';

import 'package:financed/services/networking.dart';
import 'package:flutter/material.dart';

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
  int stockDCF = 0;

  @override
  void initState() {
    super.initState();
    updateBasicDataUI(widget.txtFldEntry);
  }

  dynamic getQuote(String txtFldEntry) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://finnhub.io/api/v1/quote?symbol=$txtFldEntry&token=bsmctrvrh5r9p5dk3k0g');
    var stockQuote = await networkHelper.getData();
    return stockQuote;
  }

  dynamic getBasicData(String txtFldEntry) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://finnhub.io/api/v1/stock/profile2?symbol=$txtFldEntry&token=bsmctrvrh5r9p5dk3k0g');
    var stockBasicData = await networkHelper.getData();
    return stockBasicData;
  }

  dynamic getDCF(String txtFldEntry) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://finnhub.io/api/v1/stock/price-target?symbol=$txtFldEntry&token=bsmctrvrh5r9p5dk3k0g');
    var stockDCF = await networkHelper.getData();
    return stockDCF;
  }

  void updateBasicDataUI(dynamic txtFldEntry) async {
    var basicStockData = await getBasicData(txtFldEntry);
    var stockDCFData = await getDCF(txtFldEntry);
    var stockQuoteData = await getQuote(txtFldEntry);
    setState(() {
      //update UI stock basic data
      if (basicStockData == null) {
        stockSymbol = 'error';
        companyName = 'error';
        return;
      }
      try {
        stockSymbol = basicStockData['ticker'];
        companyName = basicStockData['name'];
      } catch (e) {
        print(e);
      }
      //update UI stock current 'c' price data
      if (stockQuoteData == null) {
        stockPrice = 0;
        return;
      }
      try {
        stockPrice = stockQuoteData['c'];
      } catch (e) {
        print(e);
      }
      //update UI stock DCF value
      if (stockDCFData == null) {
        stockDCF = 0;
        return;
      }
      try {
        stockDCF = stockDCFData['targetMedian'];

        //stockDCF = double.parse(stockDCFData['dcf'].toStringAsFixed(2));
        dateDCF = stockDCFData['lastUpdated'];

        dateDCF = dateDCF.split(" ")[0];
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
                  child: Text('Median Target Price: \$$stockDCF'),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Target Price Updated: $dateDCF'),
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
