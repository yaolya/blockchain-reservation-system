import 'package:application/models/group.dart';
import 'package:application/pages/cancellation_page.dart';
import 'package:application/pages/components/text_container.dart';
import 'package:flutter/material.dart';
import 'package:application/data_providers/items_api.dart';
import 'package:application/data_providers/user_api.dart';
import '../utils/shared_prefs.dart';

import '../models/item.dart';
import '../models/history_object.dart';
import '../models/user.dart';
import '../utils/styles.dart';
import 'components/title_container.dart';

class ItemPage extends StatefulWidget {
  static String id = '/ItemPage';
  const ItemPage({super.key, required this.item, required this.group});

  final Item item;
  final Group? group;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final itemsApi = ItemsApi();
  final userApi = UserApi();

  late bool isReserved;
  late String? ownerId;

  @override
  void initState() {
    if (widget.group != null) {
      isReserved = !((widget.group!.numberOfReservations + 1) /
              widget.group!.numberOfItems <=
          (widget.group!.overbooking / 100 + 1));
    } else {
      isReserved = widget.item.ownerId != null;
    }

    ownerId = widget.item.ownerId;
    super.initState();
  }

  List<Widget> buildAppBarActions() {
    if (isReserved && (ownerId == sharedPrefs.userId)) {
      return [
        TextButton(
          child: const Text(
            "Cancel or transfer booking",
            style: Styles.appBarButtonStyle,
          ),
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CancellationPage(item: widget.item),
              ),
            );
            setState(() {
              if (result != null) {
                isReserved = result;
              }
            });
          },
        )
      ];
    }
    if (!isReserved && (widget.item.providerId != sharedPrefs.userId)) {
      return [
        TextButton(
          onPressed: () async {
            final res =
                await itemsApi.reserveItem(widget.item.id, sharedPrefs.userId);
            if (res == 200) {
              setState(() {
                isReserved = true;
                ownerId = sharedPrefs.userId;
              });
            }
          },
          child: const Text(
            "Reserve",
            style: Styles.appBarButtonStyle,
          ),
        )
      ];
    }
    return [];
  }

  String boolToString(String boolean) {
    return (boolean == "true") ? "allowed" : "not allowed";
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
          TitleContainer(title: widget.item.name),
          TextContainer(prop: "Description", text: widget.item.description),
          TextContainer(prop: "Price", text: widget.item.price.toString()),
          TextContainer(
              prop: "Cancellation",
              text: boolToString(widget.item.cancellation)),
          TextContainer(
              prop: "Rebooking", text: boolToString(widget.item.rebooking)),
          buildProviderEmail(widget.item.providerId),
          if (widget.item.providerId == sharedPrefs.userId)
            buildItemReservations(),
          if (widget.item.providerId == sharedPrefs.userId)
            const TextContainer(prop: "History", text: ''),
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
          return TextContainer(prop: "Provider", text: user.email);
        } else {
          return const Text('');
        }
      },
    );
  }

  Widget buildUserEmailById(String userId) {
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

  Widget buildItemReservations() {
    return FutureBuilder(
      future: itemsApi.getItemReservations(widget.item.id),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          List<String> users = snapshot.data!;
          return Column(
            children: [
              const TextContainer(prop: "Currently owned", text: ""),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildUserEmailById(users[index]);
                  }),
            ],
          );
        } else {
          return const Text('');
        }
      },
    );
  }

  buildHistory(BuildContext context) {
    if (widget.item.providerId == sharedPrefs.userId) {
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
    return Container();
  }

  Widget buildTransaction(
    String date,
    String? owner,
  ) {
    return Column(
      children: [
        Row(children: [
          const Text("Date of transaction: ", style: Styles.propertyStyle),
          Text(date)
        ]),
        Row(children: [
          const Text("Owner: ", style: Styles.propertyStyle),
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
