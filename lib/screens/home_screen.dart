import 'dart:io';
import 'dart:convert';

import 'package:android/models/curso.dart';
import 'package:android/models/usuario.dart';
import 'package:android/screens/select_user_screen.dart';
import 'package:http/http.dart' as http;
import 'package:android/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android/config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final future = Future.wait([
      http.get(Uri.parse(api['cursos']!), headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${authProvider.jwtToken!}'
      }),
      http.get(Uri.parse(api['usuarios']!), headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${authProvider.jwtToken!}'
      })
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
        actions: [
          TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => context.read<AuthProvider>().unauthenticate(),
              icon: const Icon(Icons.logout_rounded),
              label: const Text("Cerrar Sesión"))
        ],
      ),
      body: Center(
          child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.data?[0].statusCode == 401 ||
              snapshot.data?[1].statusCode == 401) {
            authProvider.unauthenticate();
          } else if (snapshot.connectionState == ConnectionState.done) {
            final cursos = jsonDecode(utf8.decode(snapshot.data![0].bodyBytes))
                as List<Object?>;

            final usuarios =
                jsonDecode(utf8.decode(snapshot.data![1].bodyBytes))
                    as List<Object?>;

            List<CursoModel> cursoModels = [];
            for (var element in cursos) {
              cursoModels
                  .add(CursoModel.fromMap(element as Map<String, dynamic>));
            }

            List<UsuarioModel> usuarioModels = [];
            for (var element in usuarios) {
              usuarioModels
                  .add(UsuarioModel.fromMap(element as Map<String, dynamic>));
            }

            SelectUsersScreen.users = usuarioModels;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: cursoModels.length,
                itemBuilder: (context, index) => CursoAdapter(
                  cursoModel: cursoModels[index],
                  users: [...usuarioModels]..retainWhere((element) =>
                      cursoModels[index].estudiantes.contains(element.id)),
                  onDeleteUser: (int curso, int usuario) async {
                    final result = await http
                        .delete(Uri.parse(api['registros']!), body: {
                      "curso": curso.toString(),
                      "usuario": usuario.toString()
                    }, headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${authProvider.jwtToken!}'
                    });

                    if (result.statusCode != 200) {
                      authProvider.unauthenticate();
                    } else {
                      authProvider.reload();
                    }
                  },
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}
