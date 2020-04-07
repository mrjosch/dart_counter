import 'package:dart_counter/model/User.dart';
import 'package:dart_counter/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// create User based on FireBaseUser
  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(user.uid, user.displayName, user.email, user.photoUrl) : null;
  }

  /// auth change user stream
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFireBaseUser);
  }

  /// SignIn anonymous
  Future signInAnonymous() async {
    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// SignIn email & password
  Future signInEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  /// SignIn instagramm
  // TODO

  /// SignUp email & password
  Future signUpEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(user.uid).updateUserData(email, password); // TODO dont safe pw in db
      return _userFromFireBaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  /// SignOut
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}