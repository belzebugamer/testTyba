import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User> get authStateChanges => _auth.idTokenChanges();

  Future<String> login(String email,String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged in";
    } catch (e) {
      return "No se ha podido iniciar sesion";
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return "Logged out";
    } catch (e) {
      return "";
    }
  }

  Future<String> signUp(String email,String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } catch (e) {
      return "No se ha podido registrar el usuario";
    }
  }
}