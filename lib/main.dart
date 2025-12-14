import 'package:flutter/material.dart';
import 'package:supabase_mobile1/page/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'supabase foto', home: Home());
  }
}
