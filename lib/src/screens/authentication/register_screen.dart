import 'package:rocha_chatapp/service_locators.dart';
import 'package:rocha_chatapp/src/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCon = TextEditingController(),
      _passCon = TextEditingController(),
      _pass2Con = TextEditingController(),
      _usernameCon = TextEditingController();

  final AuthController _authController = locator<AuthController>();

  String prompts = '';

  @override
  void dispose() {
    _emailCon.dispose();
    _passCon.dispose();
    _pass2Con.dispose();
    _usernameCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff333d79),
      ),
      backgroundColor: const Color(0xfffaebef),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Image.asset("assets/images/register.png",
                      height: 120, width: 200),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Text(
                    'REGISTER',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000912),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              emailForm(),
                              passForm(),
                              conPassForm(),
                              userForm(),
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
                registerButton(),
                Text(
                  "Already have an account?",
                  style:
                      GoogleFonts.openSans(fontSize: 15, color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Login here',
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

  TextFieldWidget conPassForm() {
    return TextFieldWidget(
      controller: _pass2Con,
      hintText: 'Confirm Password',
      prefixIcon: const Icon(Icons.key_rounded,size: 25),
      obscureText: true,
      validator:(value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          } else if (_passCon.text != _pass2Con.text) {
            return 'Passwords do not match!';
          }
          return null;
        },
    );
  }

  TextFieldWidget userForm() {
    return TextFieldWidget(
      controller: _usernameCon,
      hintText: 'Username',
      prefixIcon: const Icon(Icons.people, size: 25),
      obscureText: false,
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          return null;
        },
    );
  }

  Padding registerButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: (_formKey.currentState?.validate() ?? false)
            ? () {
                _authController.register(
                  email: _emailCon.text.trim(),
                  password: _passCon.text.trim(),
                  username: _usernameCon.text.trim(),
                );
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
          'REGISTER',
          style: GoogleFonts.openSans(fontSize: 25),
        ),
      ),
    );
  }
}
