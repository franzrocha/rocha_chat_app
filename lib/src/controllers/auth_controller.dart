import 'dart:async';
import 'package:rocha_chatapp/service_locators.dart';
import 'package:rocha_chatapp/src/screens/authentication/auth_screen.dart';
import 'package:rocha_chatapp/src/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rocha_chatapp/src/controllers/navigation/navigation_service.dart';

class AuthController with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription authStream;
  User? currentUser;
  FirebaseAuthException? error;
  bool working  = true;
  final NavigationService nav = locator<NavigationService>();

  AuthController(){
    authStream = _auth.authStateChanges().listen(handleAuthUserChanges);
  }

  @override
  dispose(){
    authStream.cancel();
    super.dispose();
  }

  handleAuthUserChanges(User? event){
    if(event == null){
      print('No logged in user');
      nav.popUntilFirst();
      nav.pushReplacementNamed(AuthScreen.route);
    }
    if(event != null ){
      print('Logged in user');
      print(event.email);
      nav.pushReplacementNamed(HomeScreen.route);
    }
    error = null;
    working = false;
    currentUser = event;
    notifyListeners();
  }

  Future login(String email, String password) async {
    try {
      working = true;
      notifyListeners();
      UserCredential? result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      print(e.code);
      working = false;
      currentUser = null;
      error = e;
      notifyListeners();
    }
  }

   Future logout() async {
    working = true;
    notifyListeners();
    await _auth.signOut();
    working = false;
    notifyListeners();
    return;
  }

  Future<UserCredential?> register(
      {required String email, required String password}) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}