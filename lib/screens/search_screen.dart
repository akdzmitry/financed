import 'package:financed/screens/data_display_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String txtFldEntry = 'AAPL';

class _SearchScreenState extends State<SearchScreen> {
  void getStockData(String txtFldEntry) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataDisplayScreen(
          txtFldEntry: txtFldEntry,
        ),
      ),
    );
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
            children: <Widget>[
              Container(
                child: TextField(
                  onChanged: (textFieldValue) {
                    txtFldEntry = textFieldValue.toUpperCase();
                    print(txtFldEntry);
                  },
                ),
              ),
              FlatButton(
                onPressed: () {
                  getStockData(txtFldEntry);
                },
                child: Text(
                  "Get Data",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
