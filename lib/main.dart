import 'package:android/providers/auth_provider.dart';
import 'package:android/screens/authenticated_screen.dart';
import 'package:android/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const Application());

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider())
        ],
        builder: (_, __) => MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: const AuthenticatedScreen(HomeScreen()),
        ),
      );
}
