import 'package:location/location.dart';

//Metodo utilizado para obtener la ubicacion actual del equipo

Future<dynamic> getCurrentLocation() async {
  final Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;


//Verificamos que tenga los permisos habilitados y de lo contrario solicitamos el servicio
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

//Verificamos los permisos de la aplicacion y de lo contrario los solicitamos
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  //Se obtiene la ubicacion actual del dispositivo
  _locationData = await location.getLocation();

  return _locationData;
}
