import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? phone;
  final String? uid;
  final String? name;
  final String? address;
  final String? profileUrl;
  final String? adharCardUrl;
  final String? mainCat;
  final String? subCat;
  final String? city;
  final String? local;

  UserModel({
    required this.profileUrl,
    required this.phone,
    required this.city,
    required this.local,
    required this.uid,
    required this.name,
    required this.address,
    required this.mainCat,
    required this.subCat,
    required this.adharCardUrl,
  });

  Map<String, dynamic> toJason() => {
    'photoUrl': profileUrl,
    'phone': phone,
    'uid': uid,
    'city': city,
    'local': local,
    'adharCardUrl': adharCardUrl,
    'name': name,
    'address': address,
    'mainCat': mainCat,
    'subCat': subCat,
  };


  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;


    return UserModel(
      profileUrl: snapshot['profileUrl'],
      city: snapshot['city'],
      local: snapshot['local'],
      phone: snapshot['phone'],
      uid: snapshot['uid'],
      adharCardUrl: snapshot['adharCardUrl'],
      name: snapshot['name'],
      address: snapshot['address'],
      mainCat: snapshot['mainCat'],
      subCat: snapshot['subCat'],
    );

  }

}