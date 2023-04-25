import 'package:flutter/material.dart';
import '../data_providers/items_api.dart';
import '../extensions/validation_extension.dart';
import '../widgets/custom_form_field.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final itemsApi = ItemsApi();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
  }

  var cancellationValue = false;
  var rebookingValue = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new item'),
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
              hintText: 'Price',
              controller: priceController,
              validator: (val) {
                if (!val!.isValidPrice) {
                  return 'Enter valid price (format: 12.0)';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            CheckboxListTile(
              title: const Text("Cancellation"),
              value: cancellationValue,
              onChanged: (newValue) {
                setState(() {
                  cancellationValue = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Rebooking"),
              value: rebookingValue,
              onChanged: (newValue) {
                setState(() {
                  rebookingValue = newValue!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Future<void> onCreatePressed() async {
    if (_formKey.currentState!.validate()) {
      final res = await itemsApi.createItem(
        nameController.text,
        descriptionController.text,
        priceController.text,
        cancellationValue,
        rebookingValue,
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
        child: const Text('Create item'),
      ),
    );
  }
}
