import 'package:application/data_providers/user_api.dart';
import 'package:application/extensions/validation_extension.dart';
import 'package:application/pages/home_page.dart';
import 'package:application/pages/registration_page.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/text_error.dart';

class AuthPage extends StatefulWidget {
  static String id = '/AuthPage';
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final userApi = UserApi();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool error = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation system'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 60),
            CustomFormField(
              hintText: 'Email',
              controller: emailController,
              validator: (val) {
                if (!val!.isValidEmail) return 'Enter valid email';
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomFormField(
              hintText: 'Password',
              controller: passwordController,
              validator: (val) {
                if (!val!.isValidPassword) return 'Enter valid password';
                return null;
              },
            ),
            if (error)
              const TextError(
                message: 'Invalid credentials',
              ),
            const SizedBox(height: 15),
            buildLoginButton(),
            buildRegistrationButton(),
          ],
        ),
      ),
    );
  }

  Future<void> onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      final res = await userApi.loginUser(
        emailController.text,
        passwordController.text,
      );
      if (res == 200) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } else {
        setState(() {
          error = true;
        });
      }
    }
  }

  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: onLoginPressed,
      child: const Text('Login'),
    );
  }

  Future<void> onRegisterPressed() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
  }

  Widget buildRegistrationButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextButton(
        onPressed: onRegisterPressed,
        child: const Text('Not registered yet?'),
      ),
    );
  }
}
