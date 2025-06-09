import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller.dart';
import 'package:cocteles_app/features/cocktails/screens/widgets/ingredients_form.dart';
import 'package:cocteles_app/utils/constants/sizes.dart';
import 'package:cocteles_app/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';

class CocktailForm extends StatelessWidget {
  const CocktailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CocktailController());

    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSections),
        child: Column(
          children: [
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.name,
              validator: (value) => Validator.validateEmptyText('Nombre del cóctel', value),
              decoration: const InputDecoration(
                labelText: "Nombre del cóctel",
                prefixIcon: Icon(Iconsax.cup),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            const SizedBox(height: Sizes.spaceBtwInputFields),
            const IngredientInput(),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.creationSteps,
              maxLines: 4,
              validator: (value) => Validator.validateEmptyText('Pasos de preparación', value),
              decoration: const InputDecoration(
                labelText: "Pasos de preparación",
                prefixIcon: Icon(Iconsax.note_text),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            TextFormField(
              controller: controller.preparationTime,
              keyboardType: TextInputType.number,
              validator: (value) => Validator.validateEmptyText('Tiempo de preparación', value),
              decoration: const InputDecoration(
                labelText: "Tiempo (en minutos)",
                prefixIcon: Icon(Iconsax.timer),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            Obx(() => CheckboxListTile(
              title: const Text("Sin alcohol"),
              value: controller.isNonAlcoholic.value,
              onChanged: (value) => controller.isNonAlcoholic.value = value!,
            )),
            const SizedBox(height: Sizes.spaceBtwInputFields),

            Obx(() => Visibility(
              visible: !controller.isNonAlcoholic.value,
              child: DropdownButtonFormField<String>(
                value: controller.alcoholType.text.isNotEmpty ? controller.alcoholType.text : null,
                items: [
                  "Ron Blanco",
                  "Vodka",
                  "Tequila",
                  "Whisky",
                  "Ginebra",
                  "Mezcal"
                ].map((alcohol) => DropdownMenuItem(
                      value: alcohol,
                      child: Text(alcohol),
                    )).toList(),
                onChanged: (value) => controller.alcoholType.text = value ?? '',
                decoration: const InputDecoration(
                  labelText: "Tipo de alcohol",
                  prefixIcon: Icon(Icons.local_bar),
                ),
              ),
            )),

            const SizedBox(height: Sizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.submitCocktail(UserController.instance.userCredentials!.jwt, context),
                child: const Text("Publicar receta"),
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),
            TextButton.icon(
              icon: const Icon(Icons.rule, color: Colors.brown),
              label: const Text("Ver reglas de publicación"),
              onPressed: () => _showRulesDialog(context),
            ),
          ],
        ),
      ),
      )
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reglas para publicar un cóctel"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("📝 Requisitos mínimos:"),
              SizedBox(height: 6),
              Text("- Nombre claro del cóctel"),
              Text("- Imagen obligatoria"),
              Text("- Video obligatorio"),
              Text("- Pasos de preparación bien descritos"),
              Text("- Tiempo estimado válido"),
              Text("- Al menos 1 ingrediente con nombre y cantidad"),
              SizedBox(height: 12),
              Text("🚫 No se permite:"),
              SizedBox(height: 6),
              Text("- Contenido ofensivo"),
              Text("- Recetas duplicadas"),
              Text("- Nombres o ingredientes genéricos como 'cosa', 'eso'"),
              Text("- Imágenes tomadas de internet sin contexto"),
              Text("- Marcas comerciales innecesarias"),
              SizedBox(height: 12),
              Text("✅ Buenas prácticas:"),
              SizedBox(height: 6),
              Text("- Usa nombres comunes y bien escritos"),
              Text("- Organiza los pasos en orden lógico"),
              Text("- Usa cantidades claras (ml, oz, cucharadas)"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }
}