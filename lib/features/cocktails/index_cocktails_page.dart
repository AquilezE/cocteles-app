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

  final TextEditingController nameController = TextEditingController();
  String? selectedAlcohol;
  bool isNonAlcoholic = false;

  @override
  void initState() {
    super.initState();
    cocktailController.fetchAcceptedCocktails();
  }

  void _applyFilters() {
    cocktailController.fetchFilteredCocktails(
      name: nameController.text.trim().isNotEmpty ? nameController.text.trim() : null,
      alcoholType: selectedAlcohol,
      isNonAlcoholic: isNonAlcoholic ? true : null,
    );
  }

  void _clearFilters() {
    setState(() {
      nameController.clear();
      selectedAlcohol = null;
      isNonAlcoholic = false;
    });
    cocktailController.fetchAcceptedCocktails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cócteles")),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear cóctel',
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => const CreateCocktailPage()),
      ),
      body: Column(
        children: [
          _buildFilters(),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar por nombre',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _applyFilters(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _applyFilters,
                tooltip: "Buscar",
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedAlcohol,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de alcohol',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Ron', 'Vodka', 'Tequila', 'Whisky']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedAlcohol = value);
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Text('¿Sin alcohol?'),
                  Checkbox(
                    value: isNonAlcoholic,
                    onChanged: (value) {
                      setState(() => isNonAlcoholic = value ?? false);
                      _applyFilters();
                    },
                  ),
                ],
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text("Limpiar"),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CocktailCard extends StatelessWidget {
  final CocktailModel cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => CocktailDetailPage(cocktail: cocktail)),
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
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cocktail.name ?? 'Sin nombre',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cocktail.alcoholType ?? (cocktail.isNonAlcoholic == true ? "Sin alcohol" : "Desconocido"),
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14),
                      const SizedBox(width: 4),
                      Text('${cocktail.preparationTime} min', style: const TextStyle(fontSize: 11)),
                      const Spacer(),
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text('${cocktail.likes}', style: const TextStyle(fontSize: 11)),
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
