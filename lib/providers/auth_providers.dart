import 'package:bahm/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class AuthProvider with ChangeNotifier {
  UserModel? user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _firebaseUser;
  String? _token;

  AuthProvider(){
    loadUserFromHive();
  }

  
  String? get token => _token;
  User? get firebaseUser => _firebaseUser;

  ///Sets the firebase user and token, and saves the user to Hive.
  ///This method should be called after a successful login or signup.

  void setUser(User firebaseUser, String token) {
    _firebaseUser = firebaseUser;
    _token = token;

    user = UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User', phone: '', address: '', imageUrl: '',
    );
    final authBox = Hive.box('authBox');
    authBox.put('user', user);

    notifyListeners();
  }

   void loadUserFromHive() {
    final authBox = Hive.box('authBox');
    user = authBox.get('user');
    notifyListeners();
  }


  void logout() {
    final authBox = Hive.box('authBox');
    authBox.delete('user');
    _firebaseUser = null;
    _token = null;
    user = null;
    notifyListeners();
  }
}