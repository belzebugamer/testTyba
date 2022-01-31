/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_flutter/src/data/constants.dart';
import 'package:test_flutter/src/screens/models/restaurant.dart';
import 'package:test_flutter/src/services/fetch.dart';

class SearchFormWidget extends StatelessWidget {
  SearchFormWidget({Key key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String busqueda = "";
    return Form(
      key: _formKey,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar restaurantes',
              border: OutlineInputBorder(),
              filled: true,
            ),
            validator: (value) {
              if (value.isEmpty) {
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
              ],
            ),
            onPressed: () {
              final isValid = _formKey.currentState.validate();
              if (isValid) {
                _search(busqueda);
              }
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                primary: Colors.cyan),
          ),
        ],
      ),
    );
  }

  Future<List<Restaurant>>_search(String value) async {
    List<Restaurant> restaurant = [];
    String lng;
    String lat;
    List<String> valores;
    //Si fue ingresado una busqueda por nombre de lugar
    if (RegExp(r'[a-zA-Z]+').hasMatch(value)) {
      var res = await executeRequest(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/' +
            value +
            '.json?limit=1&access_token=' +
            mapBoxKey,
      ); /*.then((value) {
        lng = (value['features'][0]['center'][0]).toString();
        lat = (value['features'][0]['center'][1]).toString();
      });*/
      lng = (res['features'][0]['center'][0]).toString();
      lat = (res['features'][0]['center'][1]).toString();
    } else {
      valores = value.split(",");
      lng = valores[0];
      lat = valores[1];
    }
    if (lng != null && !lng.isEmpty && lat != null && !lat.isEmpty) {
      var res = await executeRequest(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/restaurant.json?type=poi&proximity=' +
              lng +
              ',' +
              lat +
              '&limit=10&access_token=' +
              mapBoxKey);
      for (var i = 0; i < res['features'].length; i++) {
        restaurant.add(Restaurant(
            id: res['features'][i]['id'],
            address: res['features'][i]['properties']['address'],
            name: res['features'][i]['text'],
            category: res['features'][i]['properties']['category']));
      }
    }
    return restaurant;
  }


}
*/