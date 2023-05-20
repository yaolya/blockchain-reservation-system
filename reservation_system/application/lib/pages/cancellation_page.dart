import 'package:application/models/item.dart';
import 'package:application/pages/components/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import '../data_providers/items_api.dart';
import '../data_providers/user_api.dart';
import '../extensions/validation_extension.dart';
import '../widgets/custom_form_field.dart';

class CancellationPage extends StatefulWidget {
  static String id = '/CancellationPage';
  const CancellationPage({super.key, required this.item});
  final Item item;

  @override
  State<CancellationPage> createState() => _CancellationPageState();
}

class _CancellationPageState extends State<CancellationPage> {
  final itemsApi = ItemsApi();
  final userApi = UserApi();
  TextEditingController newOwnerController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    newOwnerController.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel/transfer your reservation'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: buildColumn()),
        ],
      ),
    );
  }

  Widget buildColumn() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Column(
        children: [
          buildRebooking(),
          const SizedBox(height: 8.0),
          buildCancellation(),
        ],
      ),
    );
  }

  Widget buildRebooking() {
    if (widget.item.rebooking == "true") {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomFormField(
                hintText: 'New owner email',
                controller: newOwnerController,
                validator: (val) {
                  if (!val!.isValidEmail) return 'Enter valid email';
                  return null;
                },
              ),
            ),
            buildButton("Transfer booking", onTransferPressed),
            const SizedBox(height: 15),
          ],
        ),
      );
    } else {
      return const Text("Sorry, rebooking is not available for this item");
    }
  }

  Widget buildCancellation() {
    if (widget.item.cancellation == "true") {
      return buildButton("Cancel your booking", onCancelPressed);
    } else {
      return const Text("Sorry, cancellation is not available for this item");
    }
  }

  Future<void> onCancelPressed() async {
    final res = await itemsApi.cancelItem(widget.item.id);
    if (res == 200) {
      if (mounted) {
        Navigator.pop(context, false);
      }
    }
  }

  Future<void> onTransferPressed() async {
    if (_formKey.currentState!.validate()) {
      final userEmail = newOwnerController.text;
      final user = await userApi.getUserByEmail(userEmail);
      if (user != null) {
        final res = await itemsApi.transferItem(widget.item.id, user.userId);
        if (res == 200) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      } else {
        CustomAlertDialog.show("No user with such email", context: context);
      }
    }
  }

  Widget buildButton(String title, void Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
