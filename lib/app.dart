

import 'package:flutter/material.dart';
import 'package:rocha_chat_app/controllers/navigation/navigation_service.dart';
import 'package:rocha_chat_app/screens/authentication/auth_screen.dart';
import 'package:rocha_chat_app/service_locators.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      builder: (context, Widget? child) => child as Widget,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
      initialRoute: AuthScreen.route,
    );
  }

}