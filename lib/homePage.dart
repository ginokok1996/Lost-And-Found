import 'package:flutter/material.dart';
import 'package:lost_and_found/addItem.dart';
import 'package:lost_and_found/itemList.dart';
import 'package:lost_and_found/profile.dart';

class MyHomePage extends StatefulWidget {
  final author;

  MyHomePage(this.author, {Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions;

  updateIndex(index) {
    setState(() {
      _selectedIndex = int.parse(index);
    });
  }

  refresh() {}

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      ItemList(),
      AddItem(widget.author, updateIndex),
      Profile(widget.author),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[200],
          onTap: _onItemTapped,
        ));
  }
}
