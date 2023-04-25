import 'package:application/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/item.dart';
import '../models/history_object.dart';

class ItemsApi {
  Future<List<Item>> getAvailableItems() async {
    const url = 'http://localhost:8081/api/item/getAvailable';
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
      List<Item> result = [];
      for (var item in list) {
        result.add(Item.fromJson(item["Record"]));
      }
      return result;
    } else {
      throw Exception();
    }
  }

  Future createItem(
    String name,
    String description,
    String price,
    bool cancellation,
    bool rebooking,
  ) async {
    const url = 'http://localhost:8081/api/item/create';
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
        "price": price,
        "cancellation": cancellation,
        "rebooking": rebooking,
      }),
    );
    return response.statusCode;
  }

  Future reserveItem(
    String itemId,
  ) async {
    const url = 'http://localhost:8081/api/item/reserve';
    final String token = sharedPrefs.token;

    var response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
      body: json.encode({
        "itemId": itemId,
      }),
    );
    return response.statusCode;
  }

  Future cancelItem(
    String itemId,
  ) async {
    const url = 'http://localhost:8081/api/item/cancel';
    final String token = sharedPrefs.token;

    var response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
      body: json.encode({
        "itemId": itemId,
      }),
    );
    return response.statusCode;
  }

  Future<Item> getItemById(String id) async {
    final url = 'http://localhost:8081/api/item/get/$id';
    final String token = sharedPrefs.token;
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      final itemJson = jsonDecode(response.body);
      final item = Item.fromJson(itemJson);
      return item;
    } else {
      throw Exception();
    }
  }

  Future<List<Item>> getItemsByOwnerId() async {
    final String userId = sharedPrefs.userId;
    final String token = sharedPrefs.token;
    final url = 'http://localhost:8081/api/item/getAllByOwner/$userId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      List<Item> result = [];
      for (var item in list) {
        result.add(Item.fromJson(item["Record"]));
      }
      return result;
    } else {
      throw Exception();
    }
  }

  Future<List<Item>> getItemsByProviderId() async {
    final String userId = sharedPrefs.userId;
    final String token = sharedPrefs.token;
    final url = 'http://localhost:8081/api/item/getAllByCreator/$userId';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "x-access-token": token,
      },
    );
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      List<Item> result = [];
      for (var item in list) {
        result.add(Item.fromJson(item["Record"]));
      }
      return result;
    } else {
      throw Exception();
    }
  }

  Future<List<HistoryObject>> getItemHistoryById(String id) async {
    final url = 'http://localhost:8081/api/item/getHistory/$id';
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
      List<HistoryObject> result = [];
      for (var item in list) {
        var dateTime = DateTime.fromMillisecondsSinceEpoch(
            item["Timestamp"]["seconds"] * 1000);
        String convertedDateTime =
            "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
        var historyObj =
            HistoryObject(convertedDateTime, Item.fromJson(item["Value"]));
        result.add(historyObj);
      }
      return result;
    } else {
      throw Exception();
    }
  }
}
