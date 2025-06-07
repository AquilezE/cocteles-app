import 'package:flutter/material.dart';

class CocktailCommentsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> comments;

  const CocktailCommentsListWidget({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Aún no hay comentarios.", style: TextStyle(fontSize: 16)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((comment) {
        final author = comment['author'];
        final profileUrl = author?['profile_picture_path'] ?? '';
        final username = author?['username'] ?? 'Usuario';
        final text = comment['text'] ?? '';

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: profileUrl.isNotEmpty
                ? NetworkImage(profileUrl)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          title: Text(username),
          subtitle: Text(text),
        );
      }).toList(),
    );
  }
}