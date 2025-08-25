//state management for the authentication process



import 'dart:async';

import 'package:bahm/controllers/db_service.dart';
import 'package:bahm/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider  extends ChangeNotifier{

StreamSubscription<DocumentSnapshot>? _userSubscription;


String name = "User";
String email = "";
String address = "";
String phone = "";
String  imageUrl = "";


UserProvider() {
  loadUserData();
}

// load user profile data

void loadUserData(){

_userSubscription?.cancel();
_userSubscription = DbService().readUserData().listen((snapshot){

  final dataMap = snapshot.data();
  if (dataMap == null) {
    // If data is null, skip updating user data to avoid null errors
    return;
  }

  final UserModel data = UserModel.fromJson(dataMap as Map<String, dynamic>);

  name = data.name;
  email = data.email;
  address = data.address;
  phone = data.phone;
  imageUrl = data.imageUrl ?? 'https://example.com/default_image.png'; // Default image URL
  notifyListeners();

}


);


}
}