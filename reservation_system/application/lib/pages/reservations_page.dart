import 'package:flutter/material.dart';

import '../data_providers/items_api.dart';
import '../models/item.dart';

import 'item_page.dart';

class ReservationsPage extends StatefulWidget {
  static String id = '/ReservationsPage';
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  final itemsApi = ItemsApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your reservations"),
        ),
        body: Column(children: [
          FutureBuilder<List<Item>>(
            future: itemsApi.getItemsByOwnerId(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var items = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Colors.blueGrey),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemPage(
                                  item: items[index],
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Name: ${items[index].name}"),
                                Text(
                                    "Description: ${items[index].description}"),
                                Text("Price: ${items[index].price}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ]));
  }
}
