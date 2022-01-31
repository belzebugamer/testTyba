import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/src/app.dart';
import 'package:provider/provider.dart';

void main() async {
  //Verificamos la sesion actual de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
