import 'package:flutter/material.dart';

class Calculate extends StatefulWidget {
  @override
  _CalculateState createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  TextEditingController buyingController = TextEditingController();
  TextEditingController sellingController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  double profit = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: buyingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Buying Price'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: sellingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Selling Price'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: feesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Investment Fees'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: calculateProfit,
              child: Text('Calculate Profit'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Profit: \$${profit.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void calculateProfit() {
    double buyingPrice = double.tryParse(buyingController.text) ?? 0.0;
    double sellingPrice = double.tryParse(sellingController.text) ?? 0.0;
    double fees = double.tryParse(feesController.text) ?? 0.0;

    setState(() {
      profit = (sellingPrice - buyingPrice) - fees;
    });
  }
}
