import 'package:flutter/material.dart';

class UsuarioModel {
  int id;
  String username;
  String firstName;
  String lastName;

  UsuarioModel(
      {required this.id,
      required this.username,
      required this.firstName,
      required this.lastName});

  UsuarioModel.fromMap(Map<String, dynamic> json)
      : id = json['id'] as int,
        username = json['username'] as String,
        firstName = json['first_name'] as String,
        lastName = json['last_name'] as String;

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "first_name": firstName,
        "last_name": lastName
      };
}

class UsuarioCursoAdapter extends StatelessWidget {
  const UsuarioCursoAdapter(
      {required this.usuarioModel,
      this.onDelete,
      super.key,
      required this.inCurso});
  final UsuarioModel usuarioModel;
  final int inCurso;
  final void Function(int curso, int usuario)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black26, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        subtitle: Text(usuarioModel.username),
        title: Text('${usuarioModel.firstName} ${usuarioModel.lastName}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onDelete?.call(inCurso, usuarioModel.id),
        ),
      ),
    );
  }
}
