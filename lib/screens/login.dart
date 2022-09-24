// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tejaswini/constants.dart';
import 'package:tejaswini/screens/dash.dart';
import 'package:tejaswini/screens/signup.dart';
import 'package:tejaswini/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await FirebaseAuth.instance.currentUser?.refreshToken;
      await FirebaseAuth.instance.currentUser?.reload();
      if (user != null) {
        Navigator.pushNamed(context, '/dash');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("User not found"),
        ));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("wrong password"),
        ));
        print('Wrong password provided.');
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      shape: StadiumBorder(),
      backgroundColor: container,
      duration: Duration(milliseconds: 500),
      content: Text("Login Success"),
    ));
    return user;
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushNamed(context, '/dash');
    }
    return firebaseApp;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Widget build(BuildContext context) {
    double blurRadius = 10;
    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Container(
                  height: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          CustomTextField(
                            hint: 'enter  phone or e-mail',
                            isObscure: false,
                            controller: emailController,
                            lable: 'Phone or Email',
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            hint: 'enter password',
                            isObscure: true,
                            controller: passController,
                            lable: 'Password',
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      Divider(
                        color: accent,
                        thickness: 1,
                        height: 50,
                      ),
                      CustomButtomWithIcon(
                          buttonColor: container,
                          content: "Sign In",
                          textSize: 20,
                          icon: Icons.login,
                          onPressedButon: () {
                            signInUsingEmailPassword(
                                email: emailController.text.toString(),
                                password: passController.text.toString(),
                                context: context);
                            emailController.clear();
                            passController.clear();
                          }),
                      SizedBox(height: 20),
                      CustomButtomWithIcon(
                          buttonColor: container,
                          content: "No Account? Sign Up Instead",
                          onPressedButon: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/register');
                          },
                          textSize: 20,
                          icon: Icons.account_circle_outlined)
                    ],
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      )),
    );
  }
}
