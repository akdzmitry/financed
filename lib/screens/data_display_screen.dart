import 'package:flutter/material.dart';

class DataDisplayScreen extends StatefulWidget {
  DataDisplayScreen({this.stockData});
  final stockData;

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  double price = 0;

  @override
  void initState() {
    super.initState();
    updateUI(widget.stockData);
  }

  void updateUI(dynamic stockData) {
    if (stockData == null) {
      price = 64;
      return;
    }
    try {
      price = stockData[0]['price'];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display Screen'),
      ),
      body: Center(
        child: Text(
          'Stock price: $price',
        ),
      ),
    );
  }
}
