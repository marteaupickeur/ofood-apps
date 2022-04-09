// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:ofood/screens/resto.dart';
import 'package:ofood/screens/splash.dart';
import 'package:ofood/screens/agence.dart';
import 'package:ofood/screens/log.dart';
import 'package:ofood/screens/home.dart';
import 'package:ofood/screens/order.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ofood/utils/basket.dart';
import 'package:ofood/utils/currentUser.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialization of flutter for my app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Basket>(create: (_) => Basket()),
      ChangeNotifierProvider<CurrentUser>(create: (_) => CurrentUser())
    ],
    child: MaterialApp(
      color: Colors.amber,
      theme: ThemeData(primaryColor: Colors.orange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const Spalsh(),
        '/log': (context) => const Log(),
        '/agence': (context) => const Agence(),
        '/home': (context) => const Home(),
        '/resto': (context) => const Resto(),
        '/order': (context) => const Orders(),
      },
    ),
  ));
}
