import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:android/config.dart';

class AuthProvider with ChangeNotifier {
  bool isAuthenticated = false;
  String? jwtToken;

  Future<void> authenticate(String username, String password) async {
    final uri = Uri.parse(api['login']!);
    final response = await http
        .post(uri, body: {"username": username, "password": password});

    if (response.statusCode != 200) {
      return Future.error(http.ClientException(response.body));
    }

    isAuthenticated = true;
    jwtToken = jsonDecode(response.body)['access']!;
    notifyListeners();
  }

  void unauthenticate() {
    isAuthenticated = false;
    jwtToken = null;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }
}
