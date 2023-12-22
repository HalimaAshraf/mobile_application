import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udharkhatabook/customer_provider.dart';
import 'package:udharkhatabook/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UdharkhataBook',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
