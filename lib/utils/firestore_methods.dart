import 'package:areamen/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void UpdateLocation(String city, String local) async {
    final String uid = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'city': city, 'local': local});
  }


  /*Future<UserModel> getWorkersData(String cat) async {
    final data = await _firestore.collection('users').get();

  }*/


}
