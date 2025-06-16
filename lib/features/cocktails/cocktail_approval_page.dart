import 'package:cocteles_app/data/repositories/cocktails/cocktail_repository.dart';
import 'package:cocteles_app/features/cocktails/controllers/cocktail_approval_controller.dart';
import 'package:cocteles_app/features/cocktails/screens/aprove_cocktail_page.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CocktailApprovalPage extends StatelessWidget {
  final controller = Get.put(CocktailApprovalController());
  final jwt = UserController.instance.userCredentials!.jwt;

  @override
  Widget build(BuildContext context) {
    controller.fetchPendingCocktails(jwt);

    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de cócteles'), automaticallyImplyLeading: false),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        if (controller.pendingCocktails.isEmpty) {
          return const Center(child: Text('No hay cócteles pendientes de revisón.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.pendingCocktails.length,
          itemBuilder: (_, index) {
            final cocktail = controller.pendingCocktails[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final jwt = UserController.instance.userCredentials!.jwt;
                  try {
                    final fullCocktail = await CocktailRepository.instance.getFullCocktailById(cocktail.id!, jwt);
                    final result = await Get.to(() => CocktailReviewPage(cocktail: fullCocktail));

                    if (result == true) {
                      await controller.fetchPendingCocktails(jwt);
                    }
                  } catch (e) {
                    Get.snackbar("Error", "Ocurrió un error al cargar la información del cóctel, por favor intente más tarde.");
                  }
                },
                child: Row(
                  children: [
                    ClipRRect(  
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        cocktail.imageUrl ?? '',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),  
                    Expanded(
                      child: Text(
                        cocktail.name ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}