import 'package:android/models/usuario.dart';
import 'package:android/providers/auth_provider.dart';
import 'package:android/screens/select_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:android/config.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CursoModel {
  int id;
  String nombre;
  String descripcion;
  List<int> estudiantes;

  CursoModel(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.estudiantes});

  CursoModel.fromMap(Map<String, dynamic> json)
      : id = json['id'] as int,
        nombre = json['nombre'] as String,
        descripcion = json['descripcion'] as String,
        estudiantes = (json['estudiantes'] as List<dynamic>)
            .map((e) => e as int)
            .toList();

  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "estudiantes": estudiantes
      };
}

class CursoAdapter extends StatelessWidget {
  const CursoAdapter(
      {required this.cursoModel,
      this.users = const [],
      super.key,
      this.onDeleteUser});
  final CursoModel cursoModel;
  final List<UsuarioModel> users;
  final void Function(int curso, int usuario)? onDeleteUser;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    final userViews = users.map(
      (e) => UsuarioCursoAdapter(
          usuarioModel: e, onDelete: onDeleteUser, inCurso: cursoModel.id),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(cursoModel.nombre,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(cursoModel.descripcion),
          const SizedBox(
            height: 8,
          ),
          ...userViews,
          const SizedBox(
            height: 8,
          ),
          ElevatedButton.icon(
              onPressed: () async {
                final curso = cursoModel.id;
                final usuario = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const SelectUsersScreen()));
                final result = await http.post(Uri.parse(api['registros']!),
                    body: {
                      "curso": curso.toString(),
                      "usuario": usuario.toString()
                    },
                    headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${authProvider.jwtToken!}'
                    });

                if (result.statusCode != 200) {
                  authProvider.unauthenticate();
                } else {
                  authProvider.reload();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              icon: const Icon(Icons.add),
              label: const Text("Matricular"))
        ]),
      ),
    );
  }
}
