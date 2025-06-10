import 'package:flutter/material.dart';

class RegisterHeaderMobile extends StatelessWidget {
  const RegisterHeaderMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Crea tu cuenta',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Ingresa la siguiente información',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
