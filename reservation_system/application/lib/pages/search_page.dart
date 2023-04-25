import 'package:application/data_providers/items_api.dart';
import 'package:application/pages/item_page.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final itemsApi = ItemsApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      FutureBuilder<List<Item>>(
        future: itemsApi.getAvailableItems(),
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
                            Text("Description: ${items[index].description}"),
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
