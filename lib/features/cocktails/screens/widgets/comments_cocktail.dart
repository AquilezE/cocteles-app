import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller_view.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';

class CommentsWidget extends StatelessWidget {
  final int cocktailId;
  const CommentsWidget({super.key, required this.cocktailId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CocktailDetailController>();
    final username = UserController.instance.user.value.username;
    final profilePic = UserController.instance.user.value.profilePicture;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text("Comentarios", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),

        Obx(() {          
          final commentList = controller.comments;

          if (commentList.isEmpty) {
            return const Text("Sé el primero en comentar");
          }
          print("Renderizando comentarios: ${commentList.length}");

          return Column(
            children: commentList.map((comment) {
              final author = comment.author;
              final profileUrl = author?.profilePicture ?? '';
              final username = author?.username ?? 'Usuario';

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: profileUrl.isNotEmpty
                  ? NetworkImage(profileUrl)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
                title: Text(username),
                subtitle: Text(comment.text ?? ''),
              );
            }).toList(),
          );
        }),

        const SizedBox(height: 16),

        TextField(
          controller: controller.commentController,
          maxLength: 500,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Escribe un comentario...",
          ),
          maxLines: 2,
        ),

        const SizedBox(height: 8),

        ElevatedButton.icon(
          onPressed: () => controller.addComment(cocktailId),
          icon: const Icon(Icons.send),
          label: const Text("Enviar comentario"),
        ),
      ],
    );
  }
}