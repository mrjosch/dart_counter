import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;

  DatabaseService(this.uid);

  final CollectionReference collection = Firestore.instance.collection('users');

  Future updateUserData(String email, String password) async {
    return await collection.document(uid).setData({
      'email' : email,
      'password' : password
    });
  }

}