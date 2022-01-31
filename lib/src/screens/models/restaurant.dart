//Estructura de la interfaz del restaurante

class Restaurant {
  String id;
  String name;
  String address;
  String category;


  Restaurant(
      {this.id,
      this.name,
      this.address,
      this.category});

  Restaurant.initial()
      : id = null,
        name = '';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'address': this.address,
      'category': this.category,
    };
  }
}
