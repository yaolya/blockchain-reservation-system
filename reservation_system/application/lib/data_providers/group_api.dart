import 'package:application/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/group.dart';

class GroupApi {
  Future<List<Group>> getGroups() async {
    const url = 'http://localhost:8081/api/group/getAll';
    final String token = sharedPrefs.token;
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      List<Group> result = [];
      for (var group in list) {
        result.add(Group.fromJson(group["Record"]));
      }
      return result;
    } else {
      throw Exception();
    }
  }

  Future<List<Group>> getGroupsForUser() async {
    final String userId = sharedPrefs.userId;
    final String token = sharedPrefs.token;
    final url = 'http://localhost:8081/api/group/getAllByCreator/$userId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      List<Group> result = [];
      for (var group in list) {
        result.add(Group.fromJson(group["Record"]));
      }
      return result;
    } else {
      throw Exception();
    }
  }

  Future createGroup(
    String name,
    String description,
    int overbooking,
  ) async {
    const url = 'http://localhost:8081/api/group/create';
    final String token = sharedPrefs.token;

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
      body: json.encode({
        "name": name,
        "description": description,
        "overbooking": overbooking,
      }),
    );
    return response.statusCode;
  }

  Future<Group> getGroupById(String id) async {
    final url = 'http://localhost:8081/api/group/get/$id';
    final String token = sharedPrefs.token;
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      final groupJson = jsonDecode(response.body);
      final group = Group.fromJson(groupJson);
      return group;
    } else {
      throw Exception();
    }
  }
}
