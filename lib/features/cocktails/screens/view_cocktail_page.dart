import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller_view.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/utils/constants/spacing_styles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

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
    final userId = UserController.instance.user.value.id;

    detailController.checkIfLiked(cocktail.id!, userId!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nombre del cóctel", style: Theme.of(context).textTheme.titleMedium),
        Text(cocktail.name ?? 'N/A', style: const TextStyle(fontSize: 16)),

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
        if (cocktail.videoUrl != null && cocktail.videoUrl!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Video de preparación", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              //SmartYouTubePlayer(url: cocktail.videoUrl!),
            ],
          ),

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
            Text("${cocktail.likes ?? 0} likes", style: Theme.of(context).textTheme.titleMedium),
          ],
        )),

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
        ]
      ],
    );
  }
  
  void _confirmAndDelete(BuildContext context, int cocktailId) async {
    final jwt = UserController.instance.userCredentials!.jwt;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: const Text("¿Estás seguro de que deseas eliminar este cóctel? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final url = '${dotenv.env['BASE_URL']}/api/v1/cocktails/$cocktailId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwt',
      },
    );

    if (response.statusCode == 200) {
      Get.snackbar("Éxito", "El cóctel ha sido eliminado correctamente.");
    
      await Future.delayed(const Duration(milliseconds: 3000));
    
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Get.offAllNamed('/');
      }
    } else {
      Get.snackbar("Error", "No se pudo eliminar el cóctel.");
    }
  }
}
/*

class SmartYouTubePlayer extends StatefulWidget {
  final String url;
  const SmartYouTubePlayer({super.key, required this.url});

  @override
  State<SmartYouTubePlayer> createState() => _SmartYouTubePlayerState();
}

class _SmartYouTubePlayerState extends State<SmartYouTubePlayer> {
  late YoutubePlayerController _controller;

  bool get isSupportedPlatform {
    return kIsWeb || Platform.isAndroid || Platform.isIOS;
  }

  String? get videoId => YoutubePlayer.convertUrlToId(widget.url);

  @override
  void initState() {
    super.initState();

    if (isSupportedPlatform && videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (isSupportedPlatform && mounted) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isSupportedPlatform || videoId == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Este video solo está disponible en la versión móvil o web.",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => launchUrl(Uri.parse(widget.url)),
              icon: const Icon(Icons.open_in_browser),
              label: const Text("Abrir en navegador"),
            )
          ],
        ),
      );
    }

    return YoutubePlayer( controller: _controller,showVideoProgressIndicator: true, width: double.infinity,aspectRatio: 16 / 9,);
  }
}*/