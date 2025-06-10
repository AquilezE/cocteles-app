import 'package:cocteles_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class LoginHeaderMobile extends StatelessWidget{
  const LoginHeaderMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: Sizes.fontSizeMd,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Inicia sesión para continuar',
          style: TextStyle(
            fontSize: Sizes.fontSizeSm,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

}