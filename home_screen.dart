import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udharkhatabook/customer_list.dart';
import 'package:udharkhatabook/customer_provider.dart';
import 'package:udharkhatabook/screens/add_customer_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UdharBook'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.picture_as_pdf_sharp), onPressed: () => _showPdfDialog(context)),
          IconButton(icon: Icon(Icons.import_contacts_outlined), onPressed: () => _showexcelDialog(context)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                context.read<CustomerProvider>().filterCustomers(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search by name',
                icon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: CustomerList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCustomerScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPdfDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Print Database as PDF'),
          content: Text('Please attach a printer device to your device and click "Print" to generated the PDF.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _showdialog(context);
              },
              child: Text('Print'),
            ),
          ],
        );
      },
    );
  }
  void _showexcelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export DataBase as a Excel File'),
          content: Text('Your DataBase is going to exported as excel file press ok to cotinue\n you must have an excel in your device'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _showDialog(context);// Close the dialog
              },
              child: Text('ok'),
            ),
          ],
        );
      },
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error',style: TextStyle(color: Colors.redAccent,),),icon: Icon(Icons.warning),
          content: Text('Your Device does not have excel press ok to install'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('ok'),
            ),
          ],
        );
      },
    );
  }
  void _showdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error',style: TextStyle(color: Colors.redAccent,),),icon: Icon(Icons.warning),
          content: Text('please attached a printer then try again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('ok'),
            ),
          ],
        );
      },
    );
  }
}
