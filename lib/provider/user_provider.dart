import 'package:areamen/models/user_model.dart';
import 'package:areamen/utils/auth_methods.dart';
import 'package:flutter/material.dart';



class UserProvider with ChangeNotifier{
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUser();
    _user = user;
    notifyListeners();
  }
}
