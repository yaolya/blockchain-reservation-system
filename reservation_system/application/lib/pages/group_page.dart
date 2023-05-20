import 'package:application/data_providers/group_api.dart';
import 'package:application/models/group.dart';
import 'package:application/pages/components/title_container.dart';
import 'package:flutter/material.dart';

import '../data_providers/items_api.dart';
import '../models/item.dart';

import '../utils/shared_prefs.dart';
import 'components/text_container.dart';
import 'create_item_page.dart';
import 'item_page.dart';

class GroupPage extends StatefulWidget {
  static String id = '/GroupPage';
  const GroupPage({super.key, required this.group});

  final Group group;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final itemsApi = ItemsApi();
  final groupApi = GroupApi();

  List<Widget> buildAppBarActions() {
    if (widget.group.userId == sharedPrefs.userId) {
      return [
        IconButton(
          onPressed: (() {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateItemPage(groupId: widget.group.id),
                  ),
                )
                .then((_) => setState(() {}));
          }),
          icon: const Icon(Icons.add),
        ),
      ];
    } else {
      return [];
    }
  }

  Widget buildGroupOwnerInformation() {
    var reservedNumber = 0.0;
    String reserved = "0";
    if (widget.group.numberOfItems != 0) {
      reservedNumber =
          widget.group.numberOfReservations / widget.group.numberOfItems;
      reserved = reservedNumber.toStringAsFixed(2);
    }
    return Column(
      children: [
        TextContainer(
            prop: "Overbooking allowed",
            text: "${widget.group.overbooking.toString()}%"),
        TextContainer(prop: "Currently reserved", text: reserved),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: buildAppBarActions(),
        ),
        body: Column(children: [
          TitleContainer(title: widget.group.name),
          TextContainer(prop: "Description", text: widget.group.description),
          if (widget.group.userId == sharedPrefs.userId)
            buildGroupOwnerInformation(),
          FutureBuilder<List<Item>>(
            future: itemsApi.getItemsByGroup(widget.group.id),
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
                                  group: widget.group,
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
                return const Padding(
                  padding: EdgeInsets.only(top: 250.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ]));
  }
}
