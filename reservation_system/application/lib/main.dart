import 'package:application/pages/auth_page.dart';
import 'package:application/pages/edit_profile_page.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/user_groups_page.dart.dart';
import 'package:application/pages/registration_page.dart';
import 'package:application/pages/reservations_page.dart';
import 'package:application/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: AuthPage.id,
      routes: {
        AuthPage.id: (context) => const AuthPage(),
        RegistrationPage.id: (context) => const RegistrationPage(),
        HomePage.id: (context) => const HomePage(),
        UserGroupsPage.id: (context) => const UserGroupsPage(),
        ReservationsPage.id: (context) => const ReservationsPage(),
        EditProfilePage.id: (context) => const EditProfilePage(),
      },
    );
  }
}
