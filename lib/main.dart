import 'package:cooksy/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const CooksyApp());
}

class CooksyApp extends StatelessWidget {
  const CooksyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cooksy",
      theme: ThemeData(primarySwatch: Colors.orange, scaffoldBackgroundColor: Colors.grey.shade300),
      home: const HomeScreen()
    );
  }
}
