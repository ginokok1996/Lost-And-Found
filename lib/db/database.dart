import 'package:firebase_database/firebase_database.dart';
import 'package:lost_and_found/item.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference saveItem(Item item) {
  var id = databaseReference.child('items/').push();
  id.set({});
}
