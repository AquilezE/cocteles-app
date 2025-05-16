import 'package:cocteles_app/features/cocktails/index_cocktails_page.dart';
import 'package:cocteles_app/features/livestreams/controllers/livestream_controller.dart';
import 'package:cocteles_app/features/livestreams/screens/livestream_screen.dart';
import 'package:cocteles_app/features/livestreams/models/livestream_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IndexLivestreamPage extends StatelessWidget {
  IndexLivestreamPage({super.key});

  final livestreamController = Get.put(LivestreamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livestreams')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear Livestream',
        child: const Icon(Icons.add),
        onPressed: () {
          // AQUI SE DEBE CREAR UN NUEVO LIVESTREAM
          Get.to(() => ());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
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
