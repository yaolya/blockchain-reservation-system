import 'package:application/data_providers/user_api.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_form_field.dart';
import '../extensions/validation_extension.dart';

class RegistrationPage extends StatefulWidget {
  static String id = '/RegistrationPage';
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final userApi = UserApi();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            CustomFormField(
              hintText: 'Password',
              controller: passwordController,
              validator: (val) {
                if (!val!.isValidPassword) return 'Enter valid password';
                return null;
              },
            ),
            const SizedBox(height: 15),
            buildRegistrationButton(),
          ],
        ),
      ),
    );
  }

  Future<void> onRegistrationPressed() async {
    if (_formKey.currentState!.validate()) {
      var res = await userApi.registerUser(
        emailController.text,
        passwordController.text,
      );
      if (res == 200) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Widget buildRegistrationButton() {
    return ElevatedButton(
      onPressed: onRegistrationPressed,
      child: const Text('Register'),
    );
  }
}
