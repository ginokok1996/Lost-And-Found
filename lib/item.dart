import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Item extends StatefulWidget {
  String itemId;

  Item(this.itemId, {Key key}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  String author, name, description, email, image;
  var _byteImage;

  @override
  void initState() {
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child('items');

    postsRef.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      for (var key in keys) {
        if (key == widget.itemId) {
          author = data[key]['author'];
          description = data[key]['description'];
          name = data[key]['name'];
          image = data[key]['image'];
          email = data[key]['email'];
          print(author);
        }
      }

      this.setState(() {
        author = author;
        description = description;
        name = name;
        email = email;
        image = image;
      });
    });

    super.initState();
  }

  void sendMail() async {
    var url = "mailto:$email?subject=$name";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'cant send mail';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      _byteImage = Base64Decoder().convert(image);
    }
    return Scaffold(
      appBar: AppBar(
        title: name != null
            ? Text(
                name,
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'item',
                style: TextStyle(color: Colors.white),
              ),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Column(
        children: <Widget>[
          _byteImage != null
              ? Container(
                  height: 400,
                  width: double.infinity,
                  child: Image.memory(
                    _byteImage,
                    fit: BoxFit.fill,
                  ),
                )
              : Container(
                  height: 400,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Text(
            name != null ? name : 'item',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              description != null ? description : 'description',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: sendMail,
            child: Text(
              author != null ? 'Contact $author' : 'Contact ',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
