import 'package:android/models/usuario.dart';
import 'package:flutter/material.dart';

class SelectUsersScreen extends StatelessWidget {
  const SelectUsersScreen({super.key});
  static late List<UsuarioModel> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seleccionar un usuario")),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (_, i) => ListTile(
                    onTap: () => Navigator.of(context).pop(users[i].id),
                    title: Text("${users[i].firstName} ${users[i].lastName}"),
                  )),
        ],
      ),
    );
  }
}
