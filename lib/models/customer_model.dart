import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel{
  final String? phone;
  final String? uid;
  final String? name;
  final String? profileUrl;
  final String? city;
  final String? local;

  CustomerModel({
    required this.profileUrl,
    required this.phone,
    required this.city,
    required this.local,
    required this.uid,
    required this.name,
  });

  Map<String, dynamic> toJason() => {
    'photoUrl': profileUrl,
    'phone': phone,
    'uid': uid,
    'city': city,
    'local': local,
    'name': name,
  };


  static CustomerModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;


    return CustomerModel(
      profileUrl: snapshot['profileUrl'],
      city: snapshot['city'],
      local: snapshot['local'],
      phone: snapshot['phone'],
      uid: snapshot['uid'],
      name: snapshot['name'],
    );

  }

}