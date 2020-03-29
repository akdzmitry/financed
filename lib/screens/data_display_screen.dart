import 'package:flutter/material.dart';
import 'package:financed/services/networking.dart';

class DataDisplayScreen extends StatefulWidget {
  DataDisplayScreen({this.txtFldEntry});
  final txtFldEntry;

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
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
        stockPrice = 1;
        return;
      }
      try {
        stockPrice = basicStockData[0]['price'];
      } catch (e) {
        print(e);
      }
      //update UI stock DCF value
      if (stockDCFData == null) {
        stockDCF = 1;
        return;
      }
      try {
        stockDCF = stockDCFData['dcf'];
        stockDCF = double.parse(stockDCF.toStringAsFixed(2));
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display Screen'),
      ),
      body: Center(
        child: Text(
          'Stock price: $stockPrice',
        ),
      ),
    );
  }
}
