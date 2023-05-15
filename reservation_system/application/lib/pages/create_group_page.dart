import 'package:application/data_providers/group_api.dart';
import 'package:flutter/material.dart';
import '../extensions/validation_extension.dart';
import '../widgets/custom_form_field.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final groupApi = GroupApi();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController overbookingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    overbookingController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new group'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 60),
            CustomFormField(
              hintText: 'Name',
              controller: nameController,
              validator: (val) {
                if (!val!.isValidName) return 'Enter valid name';
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomFormField(
              hintText: 'Description',
              controller: descriptionController,
              validator: (val) {
                if (!val!.isValidName) return 'Enter valid description';
                return null;
              },
            ),
            const SizedBox(height: 15),
            CustomFormField(
              hintText: 'Overbooking',
              controller: overbookingController,
              validator: (val) {
                if (!val!.isValidPercent) {
                  return 'Enter valid overbooking percent (from 0 to 100)';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Future<void> onCreatePressed() async {
    if (_formKey.currentState!.validate()) {
      final res = await groupApi.createGroup(
        nameController.text,
        descriptionController.text,
        int.parse(overbookingController.text),
      );
      if (res == 200) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Widget buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: onCreatePressed,
        child: const Text('Create group'),
      ),
    );
  }
}
