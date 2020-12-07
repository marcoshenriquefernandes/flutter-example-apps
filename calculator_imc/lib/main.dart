import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = 'Informe seus dados';

  void _resetFeilds() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _infoText = 'Informe seus dados';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(_weightController.text.replaceAll(',', '.'));
      double height = double.parse(_heightController.text.replaceAll(',', '.'));
      double imc = weight / (height * height);

      if(imc < 18.6) {
        _infoText = 'Abaixo do peso (${imc.toStringAsPrecision(2)})';
      } else if(imc >= 18.6 && imc < 24.9) {
        _infoText = 'Peso ideal (${imc.toStringAsPrecision(2)})';
      } else if(imc >= 24.9 && imc < 29.9) {
        _infoText = 'Levemente acima do peso (${imc.toStringAsPrecision(2)})';
      } else if(imc >= 29.9 && imc < 34.9) {
        _infoText = 'Obesidade Grau I (${imc.toStringAsPrecision(2)})';
      } else if(imc >= 34.9 && imc < 39.9) {
        _infoText = 'Obesidade Grau II (${imc.toStringAsPrecision(2)})';
      } else if(imc >= 40) {
        _infoText = 'Obesidade Grau III (${imc.toStringAsPrecision(2)})';
      }
      print(imc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.purple[300],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _resetFeilds(),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0,  10.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.accessibility,
                size: 120.0,
                color: Colors.purple[400],
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Insira seu peso';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Peso (kg)',
                  labelStyle: TextStyle(color: Colors.purple[400]),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple[400], fontSize: 25.0),
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Insira sua altura';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Altura (cm)',
                  labelStyle: TextStyle(color: Colors.purple[400]),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple[400], fontSize: 25.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          _calculate();
                        }
                      },
                      child: Text('Calcular',
                          style: TextStyle(color: Colors.white, fontSize: 25.0)),
                      color: Colors.purple[300],
                    )),
              ),
              Text(
                '$_infoText',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple[400], fontSize: 25.0),
              )
            ],
          ),
        )
      ),
    );
  }
}
