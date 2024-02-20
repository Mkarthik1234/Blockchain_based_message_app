import 'package:flutter/material.dart';
import 'pages/homescreen.dart';
import 'pages/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});



  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }
  // Load and obtain the shared preferences for this app.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Block Chat',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight:FontWeight.normal,
                fontSize: 19),
            backgroundColor: Colors.white,
          )),
      initialRoute: '/home',
      routes: {
        '/home': (context)=>HomeScreen(),
        '/login':(context)=>Login(),
      },

    );

  }
}