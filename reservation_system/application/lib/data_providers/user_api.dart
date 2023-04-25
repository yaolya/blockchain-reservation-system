import 'package:application/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UserApi {
  Future loginUser(String email, String password) async {
    try {
      const url = 'http://localhost:8081/api/user/login';

      var response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "email": email,
          "password": password,
        }),
        headers: {"Content-Type": "application/json"},
      );
      var loginArr = json.decode(response.body);
      sharedPrefs.token = loginArr['token'];
      sharedPrefs.userId = loginArr['user']['userId'];
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }

  Future registerUser(String email, String password) async {
    const url = 'http://localhost:8081/api/user/register';

    var response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "email": email,
        "password": password,
      }),
      headers: {"Content-Type": "application/json"},
    );
    return response.statusCode;
  }

  Future updateUser(String email, String password) async {
    final String token = sharedPrefs.token;
    const url = 'http://localhost:8081/api/user/update';

    var response = await http.put(
      Uri.parse(url),
      body: json.encode({
        "email": email,
        "password": password,
      }),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    return response.statusCode;
  }

  Future<User> getUserById(String id) async {
    final url = 'http://localhost:8081/api/user/get/$id';
    final String token = sharedPrefs.token;
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      final userJson = jsonDecode(response.body);
      final user = User.fromJson(userJson);
      return user;
    } else {
      throw Exception();
    }
  }

  Future<User> getCurrentUser() async {
    final String token = sharedPrefs.token;
    final String userId = sharedPrefs.userId;
    final url = 'http://localhost:8081/api/user/get/$userId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      final userJson = jsonDecode(response.body);
      final user = User.fromJson(userJson);
      return user;
    } else {
      throw Exception();
    }
  }
}
