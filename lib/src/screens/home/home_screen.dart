import 'package:rocha_chatapp/service_locators.dart';
import 'package:rocha_chatapp/src/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _auth = locator<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Signed in'),
            IconButton(
                onPressed: () async {
                  _auth.logout();
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
      ),
    );
  }
}