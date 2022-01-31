import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:test_flutter/src/connection/server_controller.dart';
import 'package:test_flutter/src/screens/login_page.dart';
import 'package:test_flutter/src/screens/home_page.dart';
import 'package:test_flutter/src/screens/register_page.dart';
import 'package:test_flutter/src/screens/second_page.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/services/auth_services.dart';

//ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
      title: 'Material App',
      initialRoute: "/",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan.shade800,
      ),
      onGenerateRoute: (RouteSettings settings) {
        // ignore: missing_return
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case LoginPage.routeName:
              return LoginPage(context);
            case HomePage.routeName:
              return HomePage();
            case RegisterPage.routeName:
              return RegisterPage();
          }
        });
      },
    ),
    );
    
  }
}
