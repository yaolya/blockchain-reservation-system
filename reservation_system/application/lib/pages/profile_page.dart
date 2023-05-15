import 'package:application/pages/auth_page.dart';
import 'package:application/pages/edit_profile_page.dart';
import 'package:application/pages/user_groups_page.dart.dart';
import 'package:application/pages/reservations_page.dart';
import 'package:application/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

import '../data_providers/user_api.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userApi = UserApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                const Text("email: "),
                buildUserEmail(),
              ]),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserGroupsPage(),
                    ),
                  );
                },
                child: const Text('Your groups'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReservationsPage(),
                    ),
                  );
                },
                child: const Text('Reservations'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      )
                      .then((_) => setState(() {}));
                },
                child: const Text('Edit profile'),
              ),
              ElevatedButton(
                onPressed: () async {
                  sharedPrefs.remove('token');
                  sharedPrefs.remove('userId');
                  if (mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AuthPage(),
                      ),
                    );
                  }
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserEmail() {
    return FutureBuilder(
      future: userApi.getCurrentUser(),
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
