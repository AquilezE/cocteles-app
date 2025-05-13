import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cocteles_app/features/cocktails/screens/widgets/cocktail_form.dart';
import 'package:cocteles_app/features/authentication/screens/widgets/login_header_desktop.dart';
import 'package:cocteles_app/features/authentication/screens/widgets/login_header_mobile.dart';
import 'package:cocteles_app/utils/constants/spacing_styles.dart';

class CreateCocktailPage extends StatelessWidget {
  const CreateCocktailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Platform.isWindows || Platform.isMacOS || Platform.isLinux
          ? _buildDesktopLayout()
          : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return const Row(
      children: [
        Expanded(flex: 1, child: LoginHeaderDesktop()),
        Expanded(flex: 1, child: CocktailForm()),
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
