import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rocha_chat_app/firebase_options.dart';
import 'package:rocha_chat_app/service_locators.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  setupLocators();
  runApp(const MyApp());
}
  