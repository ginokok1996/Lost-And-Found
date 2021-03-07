import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert';

class AddItem extends StatefulWidget {
  final author;
  final ValueSetter<String> notifyParent;

  AddItem(this.author, this.notifyParent, {Key key}) : super(key: key);
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final referenceDatabase = FirebaseDatabase.instance;
  String _name;
  String _description;
  Io.File _uploadedImage;
  String _base64;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future cameraImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    final bytes = Io.File(image.path).readAsBytesSync();
    String base64 = base64Encode(bytes);
    setState(() {
      _uploadedImage = image;
      _base64 = base64;
    });
  }

  Future galleryImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    final bytes = Io.File(image.path).readAsBytesSync();
    String base64 = base64Encode(bytes);
    setState(() {
      _uploadedImage = image;
      _base64 = base64;
    });
  }

  Widget _image() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        _uploadedImage == null
            ? Text('Upload image')
            : Container(
                height: 200,
                child: Image.file(_uploadedImage),
              ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: cameraImage,
              child: Text(
                'Camera',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
            RaisedButton(
              onPressed: galleryImage,
              child: Text(
                'Gallery',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Name of found object (max 80 characters)'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        } else if (value.length > 80) {
          return 'Max name size is 80 letters';
        }
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          labelText: 'Description of found object (max 500 characters)'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Description is required';
        } else if (value.length > 500) {
          return 'Max description size is 500 letters';
        }
      },
      onSaved: (String value) {
        _description = value;
      },
    );
  }

  void validate() {
    final ref = referenceDatabase.reference();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var data = {};

      if (_uploadedImage != null) {
        data = {
          "author": widget.author.displayName,
          "email": widget.author.email,
          "name": _name,
          "description": _description,
          "image": _base64
        };
      } else {
        data = {
          "author": widget.author.displayName,
          "email": widget.author.email,
          "name": _name,
          "description": _description,
        };
      }

      ref.child('items').push().set(data);
      widget.notifyParent('2');
    } else {
      print('not validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Submit Item',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildName(),
                _buildDescription(),
                _image(),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: validate,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
