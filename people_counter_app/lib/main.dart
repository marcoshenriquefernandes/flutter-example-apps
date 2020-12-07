import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
      title: 'Contador de Pessoas',
      home: Home()
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _infoText = 'Restaurante vazio';

  void _changePeople(int count) {
    setState(() {
      _people += count;

      if(_people <= 0) {
        _people = 0;
        _infoText = 'Restaurante vazio';
      } else if(_people <= 10) {
        _infoText = 'Pode entrar';
      } else {
        _infoText = 'Lotado';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('images/restaurant.jpg',
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pessoas: $_people',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                      onPressed: () {
                        _changePeople(1);
                      },
                      child: Text('+1',
                          style: TextStyle(fontSize: 40, color: Colors.white))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                      onPressed: () {
                        _changePeople(-1);
                      },
                      child: Text('-1',
                          style: TextStyle(fontSize: 40, color: Colors.white))
                  ),
                ),
              ],
            ),
            Text(
              '$_infoText',
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0),
            )
          ],
        )
      ],
    );
  }
}

