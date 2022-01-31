import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(File imageFile);

class ImagePickerWidget extends StatelessWidget {
  final File imageFile;
  OnImageSelected onImageSelected;

  ImagePickerWidget({@required this.imageFile, @required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.shade300,
            Colors.cyan.shade800,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        image: imageFile != null
            ? DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: IconButton(
        icon: Icon(Icons.camera_alt),
        onPressed: () {
          _showPickerOptions(context);
        },
        iconSize: 90,
        color: Colors.white,
      ),
    );
  }

  _showPickerOptions(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              ListTile(
                title: Text("Camara"),
                leading: Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                  getImage(context,ImageSource.camera);
                },
              ),
              ListTile(
                title: Text("Galeria"),
                leading: Icon(Icons.image),
                onTap: () {
                  Navigator.pop(context);
                  getImage(context,ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  void getImage(BuildContext context, ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    this.onImageSelected(File(image.path));
  }
}
