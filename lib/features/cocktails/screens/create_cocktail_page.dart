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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Coctel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: SpacingStyles.paddingWithAppBarHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            LoginHeaderMobile(),
            CocktailForm(),
          ],
        ),
      ),
    );
  }
}