import 'package:flutter/material.dart';
import 'package:supabase_mobile1/page/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://liyrkvktshqrctjkautu.supabase.co';
const supabasekey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpeXJrdmt0c2hxcmN0amthdXR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU2OTYwNjIsImV4cCI6MjA4MTI3MjA2Mn0.74Y7EZPXIwwwYFsqrJLAwLUtyQ4WGnIbjmq8WFmQ8yg';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabasekey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'supabase foto', home: Home());
  }
}
