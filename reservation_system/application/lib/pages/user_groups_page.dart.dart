import 'package:application/data_providers/group_api.dart';
import 'package:application/models/group.dart';
import 'package:application/pages/create_group_page.dart';
import 'package:application/pages/group_page.dart';
import 'package:flutter/material.dart';

class UserGroupsPage extends StatefulWidget {
  static String id = '/UserGroupsPage';
  const UserGroupsPage({Key? key}) : super(key: key);

  @override
  State<UserGroupsPage> createState() => _UserGroupsPageState();
}

class _UserGroupsPageState extends State<UserGroupsPage> {
  final groupApi = GroupApi();

  List<Widget> buildAppBarActions() {
    return [
      IconButton(
        onPressed: (() {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const CreateGroupPage(),
                ),
              )
              .then((_) => setState(() {}));
        }),
        icon: const Icon(Icons.add),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your groups"),
          actions: buildAppBarActions(),
        ),
        body: Column(children: [
          FutureBuilder<List<Group>>(
            future: groupApi.getGroupsForUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var groups = snapshot.data!;
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
                                builder: (context) => GroupPage(
                                  group: groups[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Name: ${groups[index].name}"),
                                Text(
                                    "Description: ${groups[index].description}"),
                                Text(
                                    "Number Of Items: ${groups[index].numberOfItems}"),
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
