import 'package:flutter/material.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'item.dart';

class Profile extends StatefulWidget {
  final author;

  Profile(this.author, {Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Posts> postsList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child('items');

    postsRef.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      postsList.clear();

      for (var key in keys) {
        if (widget.author.displayName == data[key]['author']) {
          Posts posts = new Posts(
              key,
              data[key]['name'],
              data[key]['description'],
              data[key]['author'],
              data[key]['image']);

          postsList.add(posts);
        }
      }

      this.setState(() {
        postsList = postsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Image.network(widget.author.photoUrl),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.author.displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Created items:',
              ),
              Container(
                width: 300,
                child: Divider(color: Colors.grey[800]),
              ),
              Container(
                child: postsList.length == 0
                    ? Text('')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: postsList.length,
                        itemBuilder: (_, index) {
                          return PostsUI(
                              postsList[index].id,
                              postsList[index].image,
                              postsList[index].name,
                              postsList[index].description);
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String itemId, String image, String name, String description) {
    var _byteImage;
    if (image != null) {
      _byteImage = Base64Decoder().convert(image);
    }

    if (description.length > 80) {
      description = description.substring(0, 80) + '...';
    }
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        child: Row(
          children: <Widget>[
            image != null
                ? Container(
                    width: 100,
                    height: 80,
                    child: Image.memory(_byteImage),
                  )
                : Container(
                    width: 100,
                    height: 80,
                    child: Image.asset('assets/icon.png')),
            SizedBox(
              width: 5,
            ),
            Column(
              children: <Widget>[
                Text(name),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 200,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 5,
            ),
            IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Item(itemId)))
                    })
          ],
        ),
      ),
    );
  }
}
