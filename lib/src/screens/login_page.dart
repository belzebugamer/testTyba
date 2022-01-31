import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:test_flutter/src/connection/server_controller.dart';
import 'package:test_flutter/src/services/auth_services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
 
  BuildContext context;

  LoginPage(this.context, {Key key}) : super(key: key);

  //LoginPage({Key key}) : super(key: key);

  static const routeName = "/";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userName = "";
  String password = "";

  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.cyan.shade300, Colors.cyan.shade800],
              )),
              child: Image.asset(
                "assets/logo.png",
                color: Colors.white,
                height: 200,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -30),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, top: 260),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: "Usuario"),
                            onSaved: (value) {
                              userName = value;
                            },
                            //Validamos la integridad de los campos
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Contraseña",
                            ),
                            onSaved: (value) {
                              password = value;
                            },
                            //Validamos la integridad de los campos
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                            },
                            obscureText: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Iniciar sesión"),
                                  //validamos si debemos mostrar el ProgessIndicator
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
                              onPressed: () => _login(context),
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
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("¿No estas registrado?"),
                              TextButton(
                                  onPressed: () {
                                    _showRegister(context);
                                  },
                                  child: Text("Registrarse"))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//Encargado de mostrar el formulario de registro
  _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed("/register");
  }

//Metodo para realizar el login
  void _login(BuildContext context) async {
    if (!_loading) {
      if(_formKey.currentState.validate()) {
        _formKey.currentState.save();

        //Actualizamos estados de los indicadores de estado
        setState(() {
        _loading = true;
        _errorMessage = "";
      });

      //Realizamos el Login contra Firebase utilizando la libreria
      context.read<AuthService>().login(userName,password).then((value) async {
        //Si todo esta Ok, realizamos redireccion eliminando el cache para que el usuario no pueda darle atras
        Navigator.of(context).pushReplacementNamed('/home');
      });
      }
    }
  }

  @override
  void initState() {
    super.initState();
//    widget.serverController.init(widget.context);
  }
}
