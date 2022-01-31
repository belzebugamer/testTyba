import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:test_flutter/src/components/image_picker.dart';
import 'package:test_flutter/src/connection/server_controller.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/src/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  static const routeName = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "";
  String userName = "";
  String password = "";
  
  String _errorMessage = "";
  bool showPassword = false;
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
                imageFile: this.imageFile,
                onImageSelected: (File file) {
                  setState(() {
                    imageFile = file;
                  });
                }),
            SizedBox(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: kToolbarHeight + 25,
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, -30),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 260),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: ListView(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: "Nombre"),
                          onSaved: (value) {
                            name = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Usuario"),
                          onSaved: (value) {
                            userName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          onSaved: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                          obscureText: !showPassword,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          /*children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Genero",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                    title: Text(
                                      "Masculino",
                                      style: (TextStyle(fontSize: 12)),
                                    ),
                                    value: "Masculino",
                                    groupValue: "Masculino",
                                    onChanged: (value) {
                                      setState(() {
                                        genrer = value;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "Femenino",
                                      style: (TextStyle(fontSize: 12)),
                                    ),
                                    value: "Femenino",
                                    groupValue: "Femenino",
                                    onChanged: (value) {
                                      setState(() {
                                        genrer = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],*/
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Registrarse"),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                              ],
                            ),
                            onPressed: () => _register(context),
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                primary: Colors.cyan),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


//Metodo encargado de realizar el registro del usuario
  void _register(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      /*if (imageFile == null) {
        _showSnackBar(
            context, "Seleccione una imagen para continuar", Colors.grey);
        return;
      }*/

      context
          .read<AuthService>()
          .signUp(this.userName, this.password)
          .then((value) async {
        User user = FirebaseAuth.instance.currentUser;

        user.updateDisplayName(this.name);
        user.reload();
        //Construimos la instancia para guardar una coleccion de usuarios en Firebase
        await FirebaseFirestore.instance
            .collection("users")
            .doc((user.uid))
            .set({
          "uid": user.uid,
          "name": this.name,
          "email": this.userName,
          "password": this.password
        });

        //Mostramos el dialogo indicando que todo el proceso se realizo correctamente
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Informacion"),
              content: const Text("Su usuario ha sido registrado exitosamente"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      });
    }
  }

//Metodo encargado de mostrar un Snackbar para informar al usuario 
  void _showSnackBar(BuildContext context, String title, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: color,
      ),
    );
  }
}
