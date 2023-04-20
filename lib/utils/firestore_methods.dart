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



  Future<String> UpdatePersonalInfo(String id , String name , String address , String cat, String maincat ,String profUrl ) async {
    String ref = "Something went wrong";
    try{

      if (profUrl.trim().isNotEmpty) {
        await _firestore.collection('users').doc(id).update({'photoUrl' : profUrl});
      }

      if (name.trim().isNotEmpty) {
        await _firestore.collection('users').doc(id).update({'name' : name});
      }

      if (address.trim().isNotEmpty) {
        await _firestore.collection('users').doc(id).update({'address' : address});
      }

      if (cat.trim().isNotEmpty && maincat.trim().isNotEmpty) {
        await _firestore.collection('users').doc(id).update({'subCat' : cat , "mainCat" : maincat});
      }

      ref = "Success";

    }
    on FirebaseException catch(e){
      ref = e.message.toString();
    }

    return ref;
  }




/*Future<UserModel> getWorkersData(String cat) async {
    final data = await _firestore.collection('users').get();

  }*/


}
