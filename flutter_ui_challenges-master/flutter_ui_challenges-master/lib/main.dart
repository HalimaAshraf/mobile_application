import 'package:flutter/material.dart';

import 'package:flutter_ui_challenges/src/pages/profile/profile1.dart';
import 'package:flutter_ui_challenges/src/pages/profile/profile10.dart';
import 'package:flutter_ui_challenges/src/pages/profile/profile11.dart';

import 'package:flutter_ui_challenges/src/pages/profile/profile8.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter UIs',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade300,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
            .copyWith(secondary: Colors.indigo),
      ),
      home: const HomeScreen(), // Set your initial screen here
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to ProfileScreen when the button is pressed
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  const ProfileOnePage(),
                  ));
                },
                child: const Text('Profile 1'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to ProfileScreen when the button is pressed
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  const ProfileElevenPage(),
                  ));
                },
                child: const Text('Profile 2'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to ProfileScreen when the button is pressed
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  const ProfileEightPage(),
                ));
              },
              child: const Text('Profile 3'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to ProfileScreen when the button is pressed
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  const ProfileTenPage(),
                  ));
                },
                child: const Text('Profile 4'),
              ),
            ),
          ],
        ),

      ),
    );
  }
}


