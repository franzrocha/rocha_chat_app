
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rocha_chat_app/controllers/auth_controller.dart';
import 'package:rocha_chat_app/controllers/navigation/navigation_service.dart';
import 'package:rocha_chat_app/screens/authentication/register_screen.dart';
import 'package:rocha_chat_app/screens/home/home_screen.dart';
import 'package:rocha_chat_app/service_locators.dart';
import 'package:rocha_chat_app/widgets/text_field.dart';

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
  final TextEditingController _emailCon = TextEditingController(),
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
    _emailCon.dispose();
    _passCon.dispose();
    _authController.removeListener(handleLogin);
    super.dispose();
  }

  handleLogin() {
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
                          padding: const EdgeInsets.only(top: 12),
                          child: Image.asset("assets/images/chatter.png", height: 120, width: 200),),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff000912),
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Center(
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
                            )),
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

   TextFieldWidget emailForm() {
    return TextFieldWidget(
      controller: _emailCon,
      hintText: 'Email',
      prefixIcon: const Icon(Icons.email_rounded, size: 25),
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

TextFieldWidget passForm() {
    return TextFieldWidget(
      controller: _passCon,
      hintText: 'Password', 
      prefixIcon: const Icon(Icons.key,size: 25),
      obscureText: true,
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
                    _emailCon.text.trim(), _passCon.text.trim());
              }
            : null,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(350, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            primary: (_formKey.currentState?.validate() ?? false)
                ? const Color(0xff333d79)
                : Colors.black38),
        child: Text(
          'LOG IN',
          style: GoogleFonts.openSans(fontSize: 25),
        ),
      ),
    );
  }
}
