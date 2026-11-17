import 'package:flutter/material.dart';
import 'services/app_theme.dart';
import 'screens/post_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Post App',
      theme: AppTheme.lightTheme,
      home: const PostScreen(), // Halaman awal langsung Daftar Post
      debugShowCheckedModeBanner: false,
    );
  }
}