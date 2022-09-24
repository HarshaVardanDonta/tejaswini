// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:tejaswini/constants.dart';
import 'package:tejaswini/screens/login.dart';
import 'package:tejaswini/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
      print("registration success");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        shape: StadiumBorder(),
        backgroundColor: container,
        content: Text("Registration Success"),
      ));
      await db
          .collection("employees")
          .doc(
              "${FirstNameController.text.toString()} ${LastNameController.text.toString()}")
          .set({
        "name":
            "${FirstNameController.text.toString()} ${LastNameController.text.toString()}",
        "isWorking": false,
        "task": []
      });
      FirstNameController.clear();
      LastNameController.clear();
      EmailController.clear();
      Pass1Controller.clear();
      Pass2Controller.clear();

      Navigator.pushNamed(context, '/dash');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("Weak password"),
        ));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          shape: StadiumBorder(),
          backgroundColor: container,
          content: Text("Account already exists"),
        ));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  @override
  TextEditingController FirstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController Pass1Controller = TextEditingController();
  TextEditingController Pass2Controller = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                SizedBox(height: 20),
                CustomTextField(
                    hint: 'Enter your Name',
                    lable: 'First Name',
                    isObscure: false,
                    controller: FirstNameController),
                SizedBox(height: 20),
                CustomTextField(
                    hint: 'Enter Last Name',
                    lable: 'Last Name',
                    isObscure: false,
                    controller: LastNameController),
                SizedBox(height: 20),
                CustomTextField(
                    hint: 'Enter Email',
                    lable: 'E-mail',
                    isObscure: false,
                    controller: EmailController),
                SizedBox(height: 20),
                CustomTextField(
                    hint: 'Enter Password',
                    lable: 'Password',
                    isObscure: true,
                    controller: Pass1Controller),
                SizedBox(height: 20),
                CustomTextField(
                    hint: 'Enter Password again',
                    lable: 'Re-Enter Password',
                    isObscure: true,
                    controller: Pass2Controller),
                SizedBox(height: 20),
                CustomButtomWithIcon(
                    buttonColor: container,
                    content: "Sign Up",
                    onPressedButon: () {
                      if (Pass1Controller.text.toString() ==
                          Pass2Controller.text.toString()) {
                        registerUsingEmailPassword(
                            name: FirstNameController.text.toString() +
                                " " +
                                LastNameController.text.toString(),
                            email: EmailController.text.toString(),
                            password: Pass1Controller.text.toString());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(10),
                          shape: StadiumBorder(),
                          backgroundColor: container,
                          content: Text("Password mis match"),
                        ));
                      }
                    },
                    textSize: 20,
                    icon: Icons.account_circle_outlined),
                SizedBox(height: 20),
                CustomButtomWithIcon(
                    buttonColor: container,
                    content: "Sign In Instead",
                    onPressedButon: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    textSize: 20,
                    icon: Icons.login),
              ])),
        ),
      )),
    );
  }
}
