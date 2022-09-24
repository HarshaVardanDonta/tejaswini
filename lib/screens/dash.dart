// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, override_on_non_overriding_member

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tejaswini/constants.dart';
import 'package:tejaswini/screens/task.dart';
import 'package:tejaswini/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  getLoc() async {
    bool servicestatus = await Geolocator.isLocationServiceEnabled();

    if (servicestatus) {
      print("GPS service is enabled");
    } else {
      print("GPS service is disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
      } else {
        print("GPS Location service is granted");
      }
    } else {
      print("GPS Location permission granted.");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // print(position.longitude);
    // print(position.latitude);

    await db.collection("employees").doc("${currentUser?.displayName}").set({
      "location": [position.latitude, position.longitude]
    }, SetOptions(merge: true));
    // print(currentUser?.displayName.toString());
    // print(currentUser?.uid);
  }

  @override
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isWorking = false;

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    currentUser?.reload();
    currentUser?.refreshToken;

    // timer function
    final timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      getLoc();
    });

    return Scaffold(
      backgroundColor: back,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Builder(builder: (context) {
                  return IconButton(
                    color: text,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(Icons.menu, size: 30, color: text),
                  );
                }),
                CustomText(
                    color: text,
                    content: 'Dashboard',
                    size: 30,
                    weight: FontWeight.w500),
              ],
            ),
            SizedBox(height: 20),
            CustomText(
                color: text,
                content: "Welcome ${currentUser!.displayName.toString()}",
                size: 30,
                weight: FontWeight.w500),
            SizedBox(height: 50),
            //view tasks assigned by admin
            DashboardContainer(
                content: 'View tasks',
                onPress: () {
                  return showDialog(
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Task(),
                      );
                    },
                    context: context,
                  );
                },
                textWeight: FontWeight.w500,
                textSize: 20),
          ],
        )),
      )),
      drawer: Drawer(
        child: Scaffold(
          backgroundColor: back,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(backgroundColor: container),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          timer.cancel();

                          Navigator.popUntil(context, ModalRoute.withName('/'));

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(10),
                            shape: StadiumBorder(),
                            backgroundColor: container,
                            duration: Duration(milliseconds: 500),
                            content: Text("Logout Success"),
                          ));
                        },
                        child: CustomText(
                            color: text,
                            weight: FontWeight.normal,
                            size: 20,
                            content: "Logout"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: container,
        onPressed: () async {
          db
              .collection("employees")
              .doc("${currentUser.displayName}")
              .get()
              .then((value) async {
            if (value["isWorking"] == true) {
              await db
                  .collection("employees")
                  .doc("${currentUser.displayName}")
                  .set({"isWorking": false}, SetOptions(merge: true));
            } else {
              await db
                  .collection("employees")
                  .doc("${currentUser.displayName}")
                  .set({"isWorking": true}, SetOptions(merge: true));
            }
          });
        },
        child: SizedBox(
          child: StreamBuilder<DocumentSnapshot>(
            stream: db
                .collection("employees")
                .doc("${currentUser.displayName}")
                .snapshots(),
            builder: (context, streamSnapshot) {
              if (!streamSnapshot.hasData) {
                return CircularProgressIndicator();
              }
              if (streamSnapshot == null) {
                return CircularProgressIndicator();
              }
              return streamSnapshot.data?['isWorking']
                  ? Icon(Icons.work)
                  : Icon(Icons.work_off_rounded);
            },
            // child: CustomText(
            //     color: text, content: 'button', size: 20, weight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
// isWorking ? Icon(Icons.work) : Icon(Icons.work_off),
