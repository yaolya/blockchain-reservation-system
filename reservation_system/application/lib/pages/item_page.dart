import 'package:flutter/material.dart';
import 'package:application/data_providers/items_api.dart';
import 'package:application/data_providers/user_api.dart';
import '../utils/shared_prefs.dart';

import '../models/item.dart';
import '../models/history_object.dart';
import '../models/user.dart';

class ItemPage extends StatefulWidget {
  static String id = '/ItemPage';
  ItemPage({super.key, required this.item});

  late Item item;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final itemsApi = ItemsApi();
  final userApi = UserApi();
  Item? newItem;

  late bool isReserved;

  @override
  void initState() {
    super.initState();
    isReserved = (widget.item.ownerId != null);
    itemsApi.getItemById(widget.item.id).then((updatedItem) {
      setState(() {
        newItem = updatedItem;
      });
    });
  }

  final property = const TextStyle(
    fontSize: 16,
    color: Colors.blueGrey,
    fontWeight: FontWeight.bold,
  );

  List<Widget> buildAppBarActions() {
    if (isReserved &&
        (widget.item.ownerId == sharedPrefs.userId) &&
        (widget.item.cancellation == 'true')) {
      return [
        TextButton(
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            final res = await itemsApi.cancelItem(widget.item.id);
            if (res == 200) {
              setState(() {
                isReserved = false;
              });
            }
          },
        )
      ];
    }
    if (!isReserved) {
      return [
        TextButton(
          onPressed: () async {
            final res = await itemsApi.reserveItem(widget.item.id);
            if (res == 200) {
              setState(() {
                isReserved = true;
              });
            }
          },
          child: const Text(
            "Reserve",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        )
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: buildAppBarActions(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4.0),
          Container(
            color: const Color.fromARGB(255, 200, 212, 218),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          buildTextContainer("Description", widget.item.description),
          buildTextContainer("Price", widget.item.price.toString()),
          buildTextContainer("cancellation", widget.item.cancellation),
          buildProviderEmail(widget.item.providerId),
          buildTextContainer("History", ''),
          Expanded(
            child: buildHistory(context),
          ),
        ],
      ),
    );
  }

  Widget buildProviderEmail(String userId) {
    return FutureBuilder(
      future: userApi.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          User user = snapshot.data!;
          return buildTextContainer("Provider", user.email);
        } else {
          return const Text('');
        }
      },
    );
  }

  Widget buildTextContainer(String prop, String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Text("$prop: ", style: property),
        Expanded(
          child: Text(
            text,
          ),
        )
      ]),
    );
  }

  Widget buildHistory(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<HistoryObject>>(
        future: itemsApi.getItemHistoryById(widget.item.id),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<HistoryObject> items = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                items = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.blueGrey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildTransaction(
                            items[index].date,
                            items[index].item.ownerId,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildTransaction(
    String date,
    String? owner,
  ) {
    return Column(
      children: [
        Row(children: [
          Text("Date of transaction: ", style: property),
          Text(date)
        ]),
        Row(children: [
          Text("Owner: ", style: property),
          owner != null ? buildUserEmail(owner) : const Text("No"),
        ]),
      ],
    );
  }

  Widget buildUserEmail(String userId) {
    return FutureBuilder(
      future: userApi.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          User user = snapshot.data!;
          return Text(user.email);
        } else {
          return const Text('');
        }
      },
    );
  }
}
