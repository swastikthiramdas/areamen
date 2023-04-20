import 'dart:typed_data';

import 'package:areamen/models/user_model.dart';
import 'package:areamen/screens/phone_screen.dart';
import 'package:areamen/utils/storage_methods.dart';
import 'package:areamen/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUser() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }


  Future<String> signUpWorker({
    required String name,
    required String phone,
    required String address,
    required String mainCat,
    required String subCat,
    required String city,
    required String local,
    required Uint8List adharcardPhoto,
    required Uint8List profilePhoto,
  }) async {
    String res = 'Some error occurred';

    try {
      final adharcard = await StorageMethod()
          .uploadImageToStorage('adharcards/', adharcardPhoto);

      final profileurl = await StorageMethod()
          .uploadImageToStorage('profilePhotos/', profilePhoto);

      final String uid = _auth.currentUser!.uid;

      final user = UserModel(
        city: city,
        local: local,
        profileUrl: profileurl,
        phone: phone,
        uid: uid,
        name: name,
        address: address,
        mainCat: mainCat,
        subCat: subCat,
        adharCardUrl: adharcard,
      );

      await _firestore.collection('users').doc(uid).set(user.toJason());
      res = 'Success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> signUpCustomer({
    required String name,
    required Uint8List profilePhoto,
    required String phone,
    required String city,
    required String local,
  }) async {
    String ref = 'Something went wrong';
    try {

      final profileurl = await StorageMethod()
          .uploadImageToStorage('profilePhotos/', profilePhoto);

      final String uid = _auth.currentUser!.uid;


      final user = UserModel(
        city: city,
        local: local,
        profileUrl: profileurl,
        phone: phone,
        uid: uid,
        name: name, address: '', mainCat: '', subCat: '', adharCardUrl: '',
      );

      await _firestore.collection('users').doc(uid).set(user.toJason());
      ref = 'Success';

    } on FirebaseException catch (e) {
      ref = e.toString();
    }

    return ref;
  }

  signInWithPhone(String phoneNumber, Function NavigateToVarify) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          PhoneScreen.verificationcode = verificationId;
          NavigateToVarify();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  void VerifyPhoneNumber(
      String verificationId, String smsCode, Function NavigateToHome) async {
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await _auth.signInWithCredential(credential);
      NavigateToHome();
    } catch (e) {
      print(e.toString());
      /* showSnackBar(context: context, content: e.message!);*/
    }
  }
}
