import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/src/connection/server_controller.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/services/auth_services.dart';

class MyDrawer extends StatelessWidget {

  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://www.dnnsoftware.com/Portals/0/Images/hero-background-4-3.jpg"),
                    fit: BoxFit.cover)),
            accountName: Text(user.email),
            /*currentAccountPicture: CircleAvatar(
              backgroundImage: FileImage(serverController.loggedUser.photo),
            ),*/
            onDetailsPressed: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Mis buscados",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.book,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              "Cerrar sesion",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.cyan,
            ),
            onTap: () {
              context.read<AuthService>().signOut();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/");
              
            },
          ),
        ],
      ),
    );
  }
}
