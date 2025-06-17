// Widget de formulario actualizado para agregar ingredientes manualmente
// Este fragmento va dentro del CocktailForm

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller.dart';

class IngredientInput extends StatelessWidget {
  const IngredientInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CocktailController>();
    final ingredientController = TextEditingController();
    final quantityController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ingredientes *", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: ingredientController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Ingrediente',
                  prefixIcon: Icon(Iconsax.flag),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextField(
                controller: quantityController,
                maxLength: 30,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  prefixIcon: Icon(Iconsax.tag),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Iconsax.add),
              onPressed: () {
                if (ingredientController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                  controller.addManualIngredient(
                    ingredientController.text.trim(),
                    quantityController.text.trim(),
                  );
                  ingredientController.clear();
                  quantityController.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),

        Obx(() => Column(
          children: controller.manualIngredients.map((item) {
            return ListTile(
              leading: const Icon(Iconsax.flag),
              title: Text(item['name']!),
              subtitle: Text('Cantidad: ${item['quantity']}'),
              trailing: IconButton(
                icon: const Icon(Iconsax.trash),
                onPressed: () => controller.manualIngredients.remove(item),
              ),
            );
          }).toList(),
        ))
      ],
    );
  }
}