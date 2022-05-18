import 'package:rocha_chatapp/firebase_options.dart';
import 'package:rocha_chatapp/service_locators.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  setupLocators();
  runApp(const MyApp());
}
  