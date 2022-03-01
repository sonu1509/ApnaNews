import 'package:apna_news/profile.dart';
import 'package:apna_news/views/home.dart';
import 'package:apna_news/login.dart';
import 'package:apna_news/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (context) => MyLogin(),
        'register': (context) => MyRegister(),
        'home': (contaxt) => MyHome(),
        'Mprofile': (context) => UserProfile(),
      },
    ),
  );
}
