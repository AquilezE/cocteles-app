import 'dart:io';
import 'package:cocteles_app/features/createUser/screens/widgets/register_form.dart';
import 'package:cocteles_app/features/createUser/screens/widgets/register_header_desktop.dart';
import 'package:cocteles_app/features/createUser/screens/widgets/register_header_mobile.dart';
import 'package:cocteles_app/utils/constants/spacing_styles.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Platform.isWindows || Platform.isMacOS || Platform.isLinux
          ? buildDesktopLayout(context)
          : buildMobileLayout(context),
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    RegisterHeaderDesktop(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
                    SizedBox(height: 10.0),
                    RegisterForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: SpacingStyles.paddingWithAppBarHeight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  RegisterHeaderMobile(),
                  RegisterForm(),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}
