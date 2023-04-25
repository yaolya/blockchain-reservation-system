import 'package:application/extensions/validation_extension.dart';
import 'package:flutter/material.dart';
import '../data_providers/user_api.dart';
import '../widgets/custom_form_field.dart';

class EditProfilePage extends StatefulWidget {
  static String id = '/EditProfilePage';
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
        title: const Text('Edit Profile'),
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
            buildUpdateProfileButton(),
          ],
        ),
      ),
    );
  }

  Future<void> onUpdateProfilePressed() async {
    var res = await userApi.updateUser(
      emailController.text,
      passwordController.text,
    );
    if (res == 200) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget buildUpdateProfileButton() {
    return ElevatedButton(
      onPressed: onUpdateProfilePressed,
      child: const Text('Update profile'),
    );
  }
}
