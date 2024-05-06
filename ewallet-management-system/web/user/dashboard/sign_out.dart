import 'dart:html';
import 'package:web/helpers.dart';

class SignOut {
  static void signOut(ButtonElement signOut) {
    signOut.onClick.listen((event) {
      window.localStorage.removeItem('loggedInUser');
      window.alert('Logged out');
      window.location.href = '/user/login/user-login.html';
    });
  }
}
