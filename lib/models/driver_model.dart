import 'package:firebase_database/firebase_database.dart';

class DriverModel {
  String? id;
  String? name;
  String? email;
  String? phone;

  DriverModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  DriverModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = (snapshot.value as dynamic)['name'];
    email = (snapshot.value as dynamic)['email'];
    phone = (snapshot.value as dynamic)['phone'];
  }
}
