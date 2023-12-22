import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:udharkhatabook/customer_provider.dart';
import 'package:udharkhatabook/screens/home_screen.dart';

class AddCustomerScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text.trim();
                String phoneNumber = phoneNumberController.text.trim();

                if (_validateInputs(name, phoneNumber)) {
                  final customerProvider = context.read<CustomerProvider>();

                  if (!customerProvider.isCustomerAlreadySaved(name, phoneNumber)) {
                    await customerProvider.addCustomer(name, phoneNumber);

                    // Show a success message
                    _showSnackBar(context, 'Data saved successfully');

                    // Navigate back to the home screen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                    );
                  } else {
                    // Show a message if the same data is already saved
                    _showSnackBar(context, 'This customer data is already saved.');
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs(String name, String phoneNumber) {
    RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');
    RegExp phoneRegex = RegExp(r'^[0-9]+$');

    if (name.isEmpty || !nameRegex.hasMatch(name)) {
      _showSnackBar(context as BuildContext, 'Invalid name. Please enter only English alphabets.');
      return false;
    }

    if (phoneNumber.isEmpty || !phoneRegex.hasMatch(phoneNumber)) {
      _showSnackBar(context as BuildContext, 'Invalid phone number. Please enter only numeric digits.');
      return false;
    }

    return true;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
