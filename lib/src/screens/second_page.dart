import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  //const SecondPage({Key? key, required this.name}) : super(key: key); //Ejemplo 1 Con Navigator Push

  const SecondPage({Key key}) : super(key: key);

  //final String name; // Ejemplo 1

  static const routeName = '/second'; //Ejemplo 2, Con Rutas

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context).settings.arguments as SecondPageArguments;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Segunda pantalla"),
      ),
      body: Center(
        child: Text(args.name + " - " + args.lastName),
      ),
    );
  }
}


class SecondPageArguments {
  String name;
  String lastName;
  SecondPageArguments(this.name,this.lastName);
}