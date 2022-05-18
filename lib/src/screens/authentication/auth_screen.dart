import 'package:rocha_chatapp/service_locators.dart';
import 'package:rocha_chatapp/src/controllers/auth_controller.dart';
import 'package:rocha_chatapp/src/controllers/navigation/navigation_service.dart';
import 'package:rocha_chatapp/src/screens/authentication/register_screen.dart';
import 'package:rocha_chatapp/src/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  static const String route = 'auth-screen';

  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unCon = TextEditingController(),
      _passCon = TextEditingController();
  final AuthController _authController = locator<AuthController>();

  String prompts = '';

  @override
  void initState() {
    _authController.addListener(handleLogin);
    super.initState();
  }

  @override
  void dispose() {
    _authController.removeListener(handleLogin);
    super.dispose();
  }

  void handleLogin() {
    if (_authController.currentUser != null) {
      locator<NavigationService>().pushReplacementNamed(HomeScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _authController,
        builder: (context, Widget? w) {
          if (_authController.working) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xfffaebef),
                      valueColor: AlwaysStoppedAnimation(Color(0xff333d79)),
                      strokeWidth: 10,
                    )),
              ),
            );
          } else {
            return Scaffold(
              appBar: appBar(),
              backgroundColor: const Color(0xfffaebef),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          child: Text(
                            'Login',
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff000912),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          height: 300,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                color: Colors.orange.withOpacity(0.6),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Form(
                                      key: _formKey,
                                      onChanged: () {
                                        _formKey.currentState?.validate();
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          emailForm(),
                                          const SizedBox(height: 15),
                                          passForm(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _authController.error?.message ?? '',
                            style: GoogleFonts.montserrat(color: Colors.red),
                          ),
                        ),
                        loginButton(),
                        Text(
                          "Don't have an account?",
                          style: GoogleFonts.openSans(
                              fontSize: 15, color: Colors.black),
                        ),
                        TextButton(
                            onPressed: 
                            () {Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>  
                                    const RegisterScreen(),
                                    
                                  ),
                                );
                            },
                            child: Text(
                              'Register here',
                              style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  AppBar appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.message_outlined),
          const SizedBox(
            width: 6,
          ),
          Text('chatter',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              )),
        ],
      ),
      backgroundColor: const Color(0xff333d79),
    );
  }

  TextFormField emailForm() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Email',
        prefixIcon: Icon(Icons.email_rounded, size: 25),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      controller: _unCon,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  TextFormField passForm() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
        prefixIcon: Icon(Icons.wifi_password, size: 30),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      controller: _passCon,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Padding loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: (_formKey.currentState?.validate() ?? false)
            ? () {
                _authController.login(
                    _unCon.text.trim(), _passCon.text.trim());
              }
            : null,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(250, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            primary: (_formKey.currentState?.validate() ?? false)
                ? const Color(0xff333d79)
                : Colors.black38),
        child: Text(
          'Log in',
          style: GoogleFonts.openSans(fontSize: 25),
        ),
      ),
    );
  }
}
