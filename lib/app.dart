import 'package:cocteles_app/bindings/general_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cocktaily',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      initialBinding: GeneralBinding(),
      home: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: CircularProgressIndicator(color: Colors.deepOrange))),
    );
  }
}
