import 'package:rocha_chatapp/src/controllers/auth_controller.dart';
import 'package:rocha_chatapp/src/controllers/navigation/navigation_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocators() {
  locator.registerSingleton<NavigationService>(NavigationService());
  locator.registerSingleton<AuthController>(AuthController());
}