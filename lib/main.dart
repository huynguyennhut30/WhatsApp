import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/screens/People.dart';
import 'package:whatsapp/screens/calls.dart';
import 'package:whatsapp/screens/chats.dart';
import 'package:whatsapp/screens/settings.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  _connectToFirebaseEmulator();
  runApp(MyApp());
}

Future _connectToFirebaseEmulator() async {
  final fireStorePort = "8080";
  final authPort = "9099";
  final localHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
    host: "$localHost:$fireStorePort",
    sslEnabled: false,
    persistenceEnabled: false,
  );
  // await FirebaseAuth.instance.useEmulator("http://$localHost:$authPort");
  await FirebaseAuth.instance
      .useAuthEmulator("http://$localHost", int.parse(authPort));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        //Light - Darrk mode
        brightness: Brightness.light,
        primaryColor: Color(0xFF08C187),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  var screens = [Chats(), Calls(), People(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
          child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              label: "Chats",
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            ),
            BottomNavigationBarItem(
              label: "Calls",
              icon: Icon(CupertinoIcons.phone),
            ),
            BottomNavigationBarItem(
              label: "People",
              icon: Icon(CupertinoIcons.person_alt_circle),
            ),
            BottomNavigationBarItem(
              label: "Settings",
              icon: Icon(CupertinoIcons.settings_solid),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return screens[index];
        },
      )),
    );
  }
}
