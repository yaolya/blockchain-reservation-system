import 'package:flutter/material.dart';

import '../data_providers/items_api.dart';
import '../models/item.dart';

import 'create_item_page.dart';
import 'item_page.dart';

class ItemsPage extends StatefulWidget {
  static String id = '/ItemsPage';
  const ItemsPage({Key? key}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final itemsApi = ItemsApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your items"),
          actions: [
            IconButton(
              onPressed: (() {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const CreateItemPage(),
                      ),
                    )
                    .then((_) => setState(() {}));
              }),
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Column(children: [
          FutureBuilder<List<Item>>(
            future: itemsApi.getItemsByProviderId(),
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
                            );
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
