import 'package:flutter/material.dart';

// widgets
import 'package:aoc/pages/login/widgets/login_widget.dart';

// Globals
import 'package:aoc/general/globals.dart';

// Google fonts
import 'package:google_fonts/google_fonts.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/newInput.dart';

// ignore: must_be_immutable
class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var themeProv = Provider.of<ThemeProv>(context, listen: true);

    return Scaffold(
      backgroundColor: Globals.bgLightBlue,
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              'Sign In',
              style: GoogleFonts.scada(
                  textStyle: const TextStyle(fontSize: 60),
                  color: const Color.fromARGB(225, 0, 77, 121),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 350,
                child: Column(
                  children: [
                    NewInput(
                      placeholder: "Enter Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 10),
                    NewInput(
                      placeholder: "Enter Password",
                      controller: passwordController,
                      obscure: true,
                    ),
                    const SizedBox(height: 40),
                    LoginWidget(
                        text: 'Sign In',
                        pressed: () {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              )
                              .then((_) => Navigator.pushReplacementNamed(
                                  context, '/home'));
                        })
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
