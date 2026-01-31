import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/utils/theme.dart';
import 'services/provider.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'Digital Art Gallery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        if (provider.currentUser == null) {
          return const LoginScreen();
        }
        return const HomeScreen();
      },
    );
  }
}