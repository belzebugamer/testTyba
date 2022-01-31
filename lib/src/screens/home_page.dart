import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:test_flutter/src/components/my_drawer.dart';
import 'package:test_flutter/src/data/constants.dart';
import 'package:test_flutter/src/screens/models/restaurant.dart';
import 'package:test_flutter/src/services/fetch.dart';
import 'package:location/location.dart';
import 'package:test_flutter/src/services/get_location.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  //final User user;
  static const routeName = "/home";

  HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Restaurant> restaurants = [];
  final _formKey = GlobalKey<FormState>();
  String busqueda = "";
  bool _loading = false;
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    //User user = ModalRoute.of(context).settings.arguments;
    //User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurantes cercanos"),
        backgroundColor: Colors.cyan,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar restaurantes',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        restaurants.clear();
                        setState(() {});
                        return "Ingrese una ubicación";
                      } else {
                        busqueda = value;
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Buscar"),
                        if (_loading)
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(left: 20),
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                      ],
                    ),
                    onPressed: () {
                      final isValid = _formKey.currentState.validate();
                      if (isValid) {
                        _search(this.busqueda);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        primary: Colors.cyan),
                  ),
                ],
              ),
            ),
            //Para mostrar las tarjetas de los Restaurantes, validamos si esta vacia o no la lista
            restaurants.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      Restaurant restaurant = restaurants[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Card(
                            child: Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/platillos/" +
                                            random.nextInt(9).toString() +
                                            ".jpg"),
                                    fit: BoxFit.cover),
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                color: Colors.black.withOpacity(0.35),
                                child: ListTile(
                                  title: Text(
                                    restaurant.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    restaurant.address == null
                                        ? "Dirección no definida"
                                        : restaurant.address,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ))
                : Expanded(
                    child: ListView(
                      children: <Widget>[
                      const SizedBox(height: 100),
                        Image.asset("assets/empty.png"),
                      ],
                    ),
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        backgroundColor: Colors.cyan,
        onPressed: () async {
          var currentLocation = await getCurrentLocation();
          _search(currentLocation.longitude.toString() +
              "," +
              currentLocation.latitude.toString());
        },
      ),
    );
  }


  //Funcion encargada de realizar la busqueda
  //Se encarga de validar si el value ingresado es una ubicacion o coordenadas
  //El metodo es capaz de realizar la busqueda con ambas directamente
  void _search(String value) async {
    setState(() {
      _loading = true;
    });

    String lng;
    String lat;
    List<String> valores;
    //Si fue ingresado una busqueda por nombre de lugar

    //Validamos si el valor ingresado es una ubicacion 
    if (RegExp(r'[a-zA-Z]+').hasMatch(value)) {
      //Si es una ubicacion, procedemos a obtener la longitud y latitud de la ubicacion brindada
      var res = await executeRequest(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/' +
            value +
            '.json?limit=1&access_token=' +
            mapBoxKey,
      );
      lng = (res['features'][0]['center'][0]).toString();
      lat = (res['features'][0]['center'][1]).toString();
    } else {
      //Si es directamente longitud y latitud, las obtenemos
      valores = value.split(",");
      lng = valores[0];
      lat = valores[1];
    }
    //Validamos tener los datos correctos y procedemos a hacer la peticion de los POI
    if (lng != null && !lng.isEmpty && lat != null && !lat.isEmpty) {
      var res = await executeRequest(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/restaurant.json?type=poi&proximity=' +
              lng +
              ',' +
              lat +
              '&limit=10&access_token=' +
              mapBoxKey);
              
      //Limpiamos la lista de restaurantes para ingresar nuevamente valores
      restaurants.clear();
      for (var i = 0; i < res['features'].length; i++) {
        restaurants.add(Restaurant(
            id: res['features'][i]['id'],
            address: res['features'][i]['properties']['address'],
            name: res['features'][i]['text'],
            category: res['features'][i]['properties']['category']));
      }
      setState(() {
        _loading = false;
        FocusScope.of(context).unfocus();
      });
    }
  }
}
