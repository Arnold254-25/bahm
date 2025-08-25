import 'package:bahm/controllers/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  Future<String> CreateAccountWithEmail(String name, String email, String password) async {
   // Debug print
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

await DbService().saveUserData(name: name, email: email);

      return "Account Created Successfully";
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}'); // Debug print
      return e.message.toString();
    }
  }

  Future<String> LoginWithEmail(String email, String password) async {
    print('Logging in with email: $email, password: $password'); // Debug print
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}'); // Debug print
      return e.message.toString();
    }
  }

  //logout function
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //reset password function
  Future resetPassword(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Mail Sent";
    } 
   on FirebaseAuthException catch(e){
    return e.message.toString();

    }
  
  }

  //check whether user is logged in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}