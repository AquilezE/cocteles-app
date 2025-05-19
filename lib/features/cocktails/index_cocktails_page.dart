import 'package:cocteles_app/features/cocktails/screens/create_cocktail_page.dart';
import 'package:cocteles_app/features/cocktails/screens/view_cocktail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller_view.dart';
import 'package:cocteles_app/models/cocktail_model.dart';

class IndexCocktailsPage extends StatefulWidget {
  const IndexCocktailsPage({super.key});

  @override
  State<IndexCocktailsPage> createState() => _IndexCocktailsPageState();
}

class _IndexCocktailsPageState extends State<IndexCocktailsPage> {
  final cocktailController = Get.put(CocktailDetailController());

  @override
  void initState() {
    super.initState();
    cocktailController.fetchAcceptedCocktails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear cóctel',
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => const CreateCocktailPage());
        },
      ),
      body: Obx(() {
        final cocktails = cocktailController.cocktails;

        if (cocktails.isEmpty) {
          return const Center(child: Text("No hay cócteles disponibles."));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: cocktails.length,
            itemBuilder: (context, index) {
              final cocktail = cocktails[index];
              return CocktailCard(cocktail: cocktail);
            },
          ),
        );
      }),
    );
  }
}

class CocktailCard extends StatelessWidget {
  final CocktailModel cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CocktailDetailPage(cocktail: cocktail));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                cocktail.imageUrl ?? 'https://via.placeholder.com/150',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cocktail.name ?? 'Sin nombre',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cocktail.alcoholType ?? 'Sin alcohol',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14),
                      const SizedBox(width: 4),
                      Text('${cocktail.preparationTime} min', style: const TextStyle(fontSize: 10)),
                      const Spacer(),
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text('${cocktail.likes}', style: const TextStyle(fontSize: 10)),
                    ],
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