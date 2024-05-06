import 'dart:html';
import 'package:web/helpers.dart';

class User {
  final String? username;
  final String? password;

  User(this.username, this.password);
}

List<User> registeredUsers = [
  User('ali', 'ali123'),
  User('abu', 'abu123'),
  User('ahlong', 'ahlong123'),
  User('JohnDoe', 'john123'),
];

Future<bool> login(String? username, String? password) async {
  await Future.delayed(Duration(seconds: 1));
  for (var user in registeredUsers) {
    if (user.username == username && user.password == password) {
      window.localStorage['loggedInUser'] = username!;
      window.alert('Logged in: ${user.username}');
      window.location.href = '/user/dashboard/dashboard.html';
      return true;
    }
  }
  window.alert('Invalid credentials');
  throw Exception('Invalid credentials');
}

Future<void> main() async {
  if (window.localStorage['loggedInUser'] != null) {
    final user = window.localStorage['loggedInUser'];
    window.alert('Welcome back, $user');
    window.location.href = '/user/dashboard/dashboard.html';
  }

  document.getElementById('login')!.onSubmit.listen((event) async {
    event.preventDefault();
    final username =
        (document.getElementById('username') as InputElement).value;
    final password =
        (document.getElementById('password') as InputElement).value;
    try {
      await login(username, password);
    } catch (e) {
      print('Error: $e');
    }
  });
}
