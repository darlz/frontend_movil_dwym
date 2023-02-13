import 'package:android/providers/auth_provider.dart';
import 'package:android/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen(this.intended, {super.key});
  final Widget intended;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return (auth.isAuthenticated) ? intended : const LoginScreen();
  }
}
