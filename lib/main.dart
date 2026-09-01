import 'package:flutter/material.dart';
import 'doctor/doctor_main_screen.dart';
import 'Patient/Home_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Doctor Appointment App',

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: const homePage(),
    );
  }
}