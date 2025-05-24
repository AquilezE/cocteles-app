import 'package:cocteles_app/features/cocktails/controllers/cocktail_controller.dart';
import 'package:flutter/material.dart';
import 'package:cocteles_app/features/cocktails/screens/widgets/cocktail_form.dart';
import 'package:cocteles_app/features/authentication/screens/widgets/login_header_mobile.dart';
import 'package:cocteles_app/utils/constants/spacing_styles.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateCocktailPage extends StatelessWidget {
  const CreateCocktailPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.shortestSide < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Coctel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Obx(() {
            final controller = Get.put(CocktailController());
            final imageFile = controller.imageFile.value;
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              imageFile,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Center(
                            child: Text(
                              "Sin imagen seleccionada",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.pickAndSetImage(),
                    icon: const Icon(Iconsax.image),
                    label: const Text("Seleccionar imagen del cóctel"),
                  ),              const SizedBox(height: 8),  // spacing between buttons
              ElevatedButton.icon(
                onPressed: () => controller.pickAndSetVideo(),
                icon: const Icon(Icons.video_library),
                label: const Text("Selecciona el video de preparación"),
              ),
                ],
              ),
            );
          }),
        ),
        const Expanded(
          flex: 1,
          child: CocktailForm(),
        ),
      ],
    );
  }


Widget _buildMobileLayout() {
  final controller = Get.put(CocktailController());

  return SingleChildScrollView(
    padding: SpacingStyles.paddingWithAppBarHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final imageFile = controller.imageFile.value;
          return Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Text(
                          "Sin imagen seleccionada",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.pickAndSetImage(),
                icon: const Icon(Iconsax.image),
                label: const Text("Seleccionar imagen del cóctel"),
              ),
              const SizedBox(height: 8),  // spacing between buttons
              ElevatedButton.icon(
                onPressed: () => controller.pickAndSetVideo(),
                icon: const Icon(Icons.video_library),
                label: const Text("Selecciona el video de preparación"),
              ),
            ],
          );
        }),
        const SizedBox(height: 24),
        const LoginHeaderMobile(),
        const CocktailForm(),
      ],
    ),
  );
}



}