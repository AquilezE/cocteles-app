import 'package:cocteles_app/features/cocktails/index_cocktails_page.dart';
import 'package:cocteles_app/features/livestreams/controllers/livestream_controller.dart';
import 'package:cocteles_app/features/livestreams/screens/livestream_screen.dart';
import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class IndexLivestreamPage extends StatelessWidget {
  IndexLivestreamPage({super.key});

  final livestreamController = Get.put(LivestreamController());
  final _titleCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livestreams'), automaticallyImplyLeading: false),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear Livestream',
        child: const Icon(Icons.add),
        onPressed: () => _showCreateDialog(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (livestreamController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final lives = livestreamController.livestreams;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: lives.length,
            itemBuilder: (context, index) {
              final LivestreamModel live = lives[index];
              return _LivestreamCard(
                livestream: live,
                onTap: () =>
                    Get.to(() => LivestreamScreen(livestreamModel: live)),
              );
            },
          );
        }),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    _titleCtrl.clear();
    Get.dialog(
      AlertDialog(
        title: const Text('Nuevo Livestream'),
        content: TextField(
          controller: _titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final title = _titleCtrl.text.trim();
              if (title.isEmpty) return;
              Get.back(); // cerrar diálogo de título
              final session = await livestreamController.createSession(title);
              if (session != null) {
                _showInfoDialog(context, session);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showInfoDialog(BuildContext context, LivestreamModel session) {
    Get.dialog(
      AlertDialog(
        title: const Text('Transmisión creada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText('Servidor:\n${dotenv.env['STREAM_URL']}'),
            const SizedBox(height: 8),
            SelectableText('Stream key:\n${session.streamKey}'),
            const SizedBox(height: 16),
            const Text(
                'Configura OBS:\n- Pon la URL en “Media Source”.\n- Copia la clave en “Stream Key”.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }
}

class _LivestreamCard extends StatelessWidget {
  final LivestreamModel livestream;
  final VoidCallback onTap;

  const _LivestreamCard({
    super.key,
    required this.livestream,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Miniatura o placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey.shade300,
              ),
              child: const Center(
                  child: Icon(Icons.videocam, size: 40, color: Colors.white54)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    livestream.title ?? 'Sin título',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Key: ${livestream.streamKey}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
