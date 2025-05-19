import 'package:flutter/material.dart';
import 'package:cocteles_app/models/cocktail_model.dart';
import 'package:cocteles_app/utils/constants/spacing_styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

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
              Text(cocktail.videoUrl!, style: const TextStyle(color: Colors.blue)),
            ],
          ),

        const SizedBox(height: 24),
        Text("Likes: ${cocktail.likes ?? 0}", style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}