import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=61da9450";

void main() async {
//  http.Response response = await http.get(request);
//  print(json.decode(response.body)["results"]["currencies"]["USD"]);
//  print(await getData());

  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              )
          )
      )
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar*this.dolar)/euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro*this.euro)/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  "Carregando dados.. ",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Erro ao carregar dados!",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                ),
              );
            } else {
              dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
              euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 150.0,
                      color: Colors.amber,
                    ),
                    Divider(),
                    buildTextField("Reais", "R\$", realController, this._realChanged),
                    Divider(),
                    buildTextField("Euros", "US\$", euroController, this._euroChanged),
                    Divider(),
                    buildTextField("Euros", "€", dolarController, this._dolarChanged)

                  ],
                ),
              );
            }
          },
        ));
  }
}


Widget buildTextField(String label, String prefixo, TextEditingController c, Function f){
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber) ,
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
    controller: c,
  );
}