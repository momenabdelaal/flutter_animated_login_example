import 'package:flutter/material.dart';

import 'Login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
        title: 'Name App',
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),


    );
  }
}
