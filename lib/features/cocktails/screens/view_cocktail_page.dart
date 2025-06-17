import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller_view.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:cocteles_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/utils/constants/spacing_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/cocktails/screens/widgets/video_player_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cocteles_app/features/cocktails/screens/widgets/comments_cocktail.dart';

class CocktailDetailPage extends StatelessWidget {
  final CocktailModel cocktail;
  const CocktailDetailPage({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktail.name ?? 'Detalle del Cóctel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildDesktopLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: cocktail.imageUrl != null && cocktail.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        cocktail.imageUrl!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Center(
                      child: Text(
                        "Sin imagen disponible",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: _buildCocktailInfo(context),
            )
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: SpacingStyles.paddingWithAppBarHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cocktail.imageUrl != null && cocktail.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                cocktail.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          _buildCocktailInfo(context),
        ],
      ),
    );
  }
  
  Widget _buildCocktailInfo(BuildContext context) {
    final detailController = Get.find<CocktailDetailController>();
    final jwt = UserController.instance.userCredentials!.jwt;

    detailController.fetchCocktailById(cocktail.id!, jwt);
    detailController.checkIfLiked(cocktail.id!, UserController.instance.user.value.id!);
    detailController.fetchComments(cocktail.id!, jwt);

    final videoNotifier = ValueNotifier<XFile?>(null);
    final videoFuture = detailController.getVideoDownloadedFuture(cocktail.videoUrl!, jwt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nombre del cóctel", style: Theme.of(context).textTheme.titleMedium),
        Text(cocktail.name ?? 'N/A', style: const TextStyle(fontSize: 16)),

        const SizedBox(height: 16),
        Text("Autor", style: Theme.of(context).textTheme.titleMedium),
        Text(cocktail.authorName ?? 'No especificado'),

        const SizedBox(height: 16),
        Text("Pasos de preparación", style: Theme.of(context).textTheme.titleMedium),
        Text(cocktail.creationSteps ?? 'N/A'),

        const SizedBox(height: 16),
        Text("Tiempo de preparación", style: Theme.of(context).textTheme.titleMedium),
        Text("${cocktail.preparationTime ?? 0} minutos"),

        const SizedBox(height: 16),
        Text("Ingredientes", style: Theme.of(context).textTheme.titleMedium),
        ...?cocktail.ingredients?.map((i) => ListTile(
          leading: const Icon(Iconsax.flag),
          title: Text(i['name']),
          subtitle: Text('Cantidad: ${i['CocktailIngredient']?['quantity'] ?? 'No especificado'}'),
        )),

        const SizedBox(height: 16),
        Text("¿Es sin alcohol?", style: Theme.of(context).textTheme.titleMedium),
        Text(cocktail.isNonAlcoholic == true ? 'Sí' : 'No'),

        if (cocktail.isNonAlcoholic == false) ...[
          const SizedBox(height: 16),
          Text("Tipo de alcohol", style: Theme.of(context).textTheme.titleMedium),
          Text(cocktail.alcoholType ?? 'No especificado'),
        ],

        const SizedBox(height: 16),
        if (cocktail.videoUrl != null && cocktail.videoUrl!.isNotEmpty) ...[
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
          )
        ] else ...[
          const SizedBox(height: Sizes.spaceBtwSections),
          ValueListenableBuilder<XFile?>(
            valueListenable: videoNotifier,
            builder: (context, video, child) {
              if (video != null) {
                detailController.video = video;
              }
              return const SizedBox.shrink();
            },
          )
        ],

        const SizedBox(height: 24),
        Obx(() => Row(
          children: [
            IconButton(
              icon: Icon(
                detailController.hasLiked.value ? Icons.favorite : Icons.favorite_border,
                color: detailController.hasLiked.value ? Colors.red : null,
              ),
              onPressed: () => detailController.toggleLike(cocktail.id!, jwt),
            ),
            Text("${detailController.cocktail?.likes ?? 0} likes",
              style: Theme.of(context).textTheme.titleMedium),
          ],
        )),

        CommentsWidget(cocktailId: cocktail.id!),

        if (UserController.instance.userCredentials?.role != 'user') ...[
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _confirmAndDelete(context, cocktail.id!),
            icon: const Icon(Icons.delete),
            label: const Text("Eliminar cóctel"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  void _confirmAndDelete(BuildContext context, int cocktailId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Estás seguro de que quieres eliminar este cóctel? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Eliminar"),
            onPressed: () {
              Navigator.of(ctx).pop();
              final detailController = Get.find<CocktailDetailController>();
              detailController.deleteCocktail(cocktailId);
            },
          ),
        ],
      ),
    );
  }
}