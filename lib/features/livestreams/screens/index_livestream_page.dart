import 'package:cocteles_app/features/cocktails/index_cocktails_page.dart';
import 'package:cocteles_app/features/livestreams/controllers/livestream_controller.dart';
import 'package:cocteles_app/features/livestreams/screens/livestream_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IndexLivestreamPage extends StatelessWidget {
  IndexLivestreamPage({super.key});

  final livestreamController = Get.put(LivestreamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear coctel',
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => LivestreamScreen());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 2,
          itemBuilder: (context, index) {},
        ),
      ),
    );
  }
}
