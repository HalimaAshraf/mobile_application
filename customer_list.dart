import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udharkhatabook/customer.dart';
import 'package:udharkhatabook/customer_provider.dart';
import 'package:udharkhatabook/screens/transaction_detail_screen.dart';// Import the CustomerDetailScreen

class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Customer> customers = context.watch<CustomerProvider>().filteredCustomers;

    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigate to the CustomerDetailScreen when a customer is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Text(customers[index].name),
          ),
        );
      },
    );
  }
}
