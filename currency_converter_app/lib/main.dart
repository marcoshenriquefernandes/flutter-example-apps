import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance';

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber)
        ),
        hintStyle: TextStyle(color: Colors.amber),
      )
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _realController = TextEditingController();
  final _dollarController = TextEditingController();
  final _eurosController = TextEditingController();

  double _dollar;
  double _euro;

  void _clearAll() {
    _realController.text = '';
    _dollarController.text = '';
    _eurosController.text = '';
  }

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    _dollarController.text = (real/_dollar).toStringAsFixed(2);
    _eurosController.text = (real/_euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dollar = double.parse(text);
    _realController.text = (dollar * this._dollar).toStringAsFixed(2);
    _eurosController.text = (dollar * this._dollar / _euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    _realController.text = (euro * this._euro).toStringAsFixed(2);
    _dollarController.text = (euro * this._euro / _dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Conversor de Moedas'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none :
            case ConnectionState.waiting :
              return Center(
                child: Text('Carregando Dados...',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                ),
              );
            default:
              if(snapshot.hasError) {
                return Center(
                  child: Text('Erro ao Carregar Dados!',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                );
              } else {
                _dollar = snapshot.data['results']['currencies']['USD']['buy'];
                _euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on_outlined, size: 150.0, color: Colors.amber,),
                      Divider(),
                      buildTextField('Reais', 'R\$', _realController, _realChanged),
                      Divider(),
                      buildTextField('Doláres', 'US\$', _dollarController, _dollarChanged),
                      Divider(),
                      buildTextField('Euros', '€', _eurosController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      )
    );
  }
}

Widget buildTextField(String label, String prefixTxt, TextEditingController control, Function function) {
  return TextField(
    controller: control,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefixTxt,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}