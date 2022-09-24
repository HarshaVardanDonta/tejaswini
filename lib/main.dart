// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tejaswini/screens/dash.dart';
import 'package:tejaswini/screens/login.dart';
import 'package:flutter/services.dart';
import 'package:tejaswini/screens/signup.dart';
import 'package:geolocator/geolocator.dart';

User? currentUser = FirebaseAuth.instance.currentUser;

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

  await FirebaseFirestore.instance
      .collection("employees")
      .doc("${currentUser?.displayName}")
      .set({
    "location": [position.latitude, position.longitude]
  }, SetOptions(merge: true));
  // print(currentUser?.displayName.toString());
  // print(currentUser?.uid);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //
  // LocationPermission permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.denied) {
  //   permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied) {
  //     print('Location permissions are denied');
  //   } else if (permission == LocationPermission.deniedForever) {
  //     print("'Location permissions are permanently denied");
  //   } else {
  //     print("GPS Location service is granted");
  //   }
  // } else {
  //   print("GPS Location permission granted.");
  // }
  await initializeService();
  // FlutterBackgroundService().initialize();
  runApp(MyApp());
}

Future<void> initializeService() async {

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tejaswini',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => SignUp(),
        '/dash': (context) => DashBoard(),
      },
    );
  }
}

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
