import 'package:android/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var username = "";
    var password = "";

    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Iniciar Sesión",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) => (username = value),
                  decoration: const InputDecoration(
                    hintText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No puede estar vacío';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) => (password = value),
                  decoration: const InputDecoration(
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No puede estar vacío';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text("Iniciar Sesión"),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Attempt authentication
                      try {
                        await context
                            .read<AuthProvider>()
                            .authenticate(username, password);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Inicio de sesión fallido:\n${e.toString()}")),
                        );
                      }
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
