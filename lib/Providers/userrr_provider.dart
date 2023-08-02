import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olxclone/Models/user_model.dart';
import 'package:olxclone/Resources/auth_methods.dart';

class UserrrProviderr with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }


}
