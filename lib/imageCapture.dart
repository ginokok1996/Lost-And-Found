import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selectedFile = await ImagePicker().getImage(source: source);
    File selected = File(selectedFile.path);

    setState(() => _imageFile = selected);
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ListView(
          children: <Widget>[
            if (_imageFile != null) ...[Image.file(_imageFile)]
          ],
        ),
        IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () => _pickImage(ImageSource.camera)),
        IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () => _pickImage(ImageSource.gallery))
      ],
    );
  }
}
