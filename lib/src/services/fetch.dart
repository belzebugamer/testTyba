import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



//Metodo encargado de ejectuar una peticion de tipo GET y retornar un JSON como resultado
Future<dynamic> executeRequest(String url) async {
  final response =
      await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Si la llamada al servidor fue exitosa, analiza el JSON
    final parsedJson = jsonDecode(response.body);
    return parsedJson;
  } else {
    // Si la llamada no fue exitosa, lanza un error.
    throw Exception('Failed to load data');
  }
}
