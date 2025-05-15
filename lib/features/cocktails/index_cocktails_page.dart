import 'package:cocteles_app/features/cocktails/screens/create_cocktail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller.dart';
import 'package:cocteles_app/models/cocktail_model.dart';

class IndexCocktailsPage extends StatelessWidget {
  IndexCocktailsPage({super.key});

  final cocktailController = Get.put(CocktailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear coctel',
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => CreateCocktailPage());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // less outer padding
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // each card will be at most 200px wide
            childAspectRatio: 0.65, // tweak this to get the height you like
            crossAxisSpacing: 8, // smaller gutters
            mainAxisSpacing: 8,
          ),
          itemCount: cocktailController.cocktails.length,
          itemBuilder: (context, index) {
            final cocktail = cocktailController.cocktails[index];
            return CocktailCard(cocktail: cocktail);
          },
        ),
      ),
    );
  }
}

class CocktailCard extends StatelessWidget {
  final CocktailModel cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              cocktail.imageUrl ?? 'https://via.placeholder.com/150',
              height: 100, // was 120
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 4.0, vertical: 6.0), // was all:6
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cocktail.name ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 12, // was 14
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cocktail.alcoholType ?? 'Sin alcohol',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10, // was 12
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14), // slightly smaller
                    const SizedBox(width: 4),
                    Text('${cocktail.preparationTime} min',
                        style: const TextStyle(fontSize: 10)),
                    const Spacer(),
                    const Icon(Icons.favorite, size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${cocktail.likes}',
                        style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
