import 'package:flutter/material.dart';

class RegisterHeaderDesktop extends StatelessWidget {
  const RegisterHeaderDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Create your account',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Enter the following information to create your account',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
