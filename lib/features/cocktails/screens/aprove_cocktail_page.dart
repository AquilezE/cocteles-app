import 'dart:convert';
import 'package:cocteles_app/data/services/video_service.dart';
import 'package:cocteles_app/features/stats/controllers/StatsController.dart';
import 'package:http/http.dart' as http;
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/utils/http_client.dart';
import 'package:cocteles_app/features/cocktails/screens/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CocktailReviewPage extends StatelessWidget {
  final CocktailModel cocktail;
  const CocktailReviewPage({super.key, required this.cocktail});
  static StatsController get statsController => Get.find<StatsController>();

  @override
  Widget build(BuildContext context) {
    final jwt = UserController.instance.userCredentials!.jwt;
    final videoFuture = cocktail.videoUrl != null
      ? VideoService(jwt: jwt).startDownload(cocktail.videoUrl!)
      : Future.value(null);
    final videoUrl = cocktail.videoUrl != null && cocktail.videoUrl!.isNotEmpty
      ? '${AppHttpHelper.baseUrl}/uploads/${cocktail.videoUrl}'
      : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Revisión: ${cocktail.name ?? ''}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cocktail.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(cocktail.imageUrl!),
              ),

            const SizedBox(height: 16),

            Text("Autor:", style: Theme.of(context).textTheme.titleMedium),
            Text(cocktail.authorName ?? 'No especificado'),

            const SizedBox(height: 16),

            Text("Pasos de preparación:", style: Theme.of(context).textTheme.titleMedium),
            Text(cocktail.creationSteps ?? 'N/A'),

            const SizedBox(height: 16),

            Text("Tiempo: ${cocktail.preparationTime ?? 0} minutos"),

            const SizedBox(height: 16),

            Text("Ingredientes:", style: Theme.of(context).textTheme.titleMedium),
            ...?cocktail.ingredients?.map((i) => Text(
              "- ${i['name']} (${i['CocktailIngredient']?['quantity'] ?? 'cantidad desconocida'})"
            )),

            const SizedBox(height: 16),

            Text("Tipo de cóctel: ${cocktail.isNonAlcoholic == true ? 'Sin alcohol' : 'Con alcohol'}"),
            if (cocktail.isNonAlcoholic == false)
              Text("Tipo de alcohol: ${cocktail.alcoholType ?? 'N/A'}"),

            if (videoUrl != null) ...[
              const SizedBox(height: 24),
              Text("Video de preparación", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              FutureBuilder<XFile?>(
                future: videoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.orange);
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    final video = snapshot.data;
                    if (video != null) {
                      return VideoPlayerWidget(url: video.path);
                    } else {
                      return const Text("No se pudo descargar el video", style: TextStyle(color: Colors.red));
                      }
                  }
                },
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveCocktail(context),
                    icon: const Icon(Icons.check),
                    label: const Text("Aprobar"),
                    style: ElevatedButton.styleFrom(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectCocktail(context),
                    icon: const Icon(Icons.close),
                    label: const Text("Rechazar"),
                    style: ElevatedButton.styleFrom(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _approveCocktail(BuildContext context) async {
    final jwt = UserController.instance.userCredentials!.jwt;
    final url = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/cocktails/accept/${cocktail.id}');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      await statsController.fetchMonthlyStats();
      Get.snackbar("Aprobado", "La receta ha sido aprobada correctamente.");
      await Future.delayed(const Duration(milliseconds: 3000));
      Navigator.pop(context, true);
    }
    else {
      Get.snackbar("Error", "No se pudo aprobar la receta.");
    }
  }

  void _rejectCocktail(BuildContext context) async {
    final reason = await _showRejectionDialog(context);
    if (reason == null || reason.isEmpty) {
      Get.snackbar("Error", "Debes escribir un motivo para rechazar");
      return;
    }

    final jwt = UserController.instance.userCredentials!.jwt;
    final url = Uri.parse('${AppHttpHelper.baseUrl}/api/v1/cocktails/reject/${cocktail.id}');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"reason": reason}),
    );

    if (response.statusCode == 200) {
      Get.snackbar("Rechazado", "El cóctel ha sido rechazado correctamente.");
      await Future.delayed(const Duration(milliseconds: 3000));
      Navigator.pop(context, true);
    }
    else {
      Get.snackbar("Error", "No se pudo rechazar el cóctel.");
    }
  }

  Future<String?> _showRejectionDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Motivo de rechazo"),
        content: TextField(
          controller: controller,
          maxLength: 250,
          decoration: const InputDecoration(hintText: "Escribe el motivo"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text("Enviar")),
        ],
      ),
    );
  }
}