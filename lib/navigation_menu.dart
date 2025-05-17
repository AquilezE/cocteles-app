import 'dart:async';
import 'dart:ffi';

import 'package:cocteles_app/features/authentication/models/user_credentials.dart';
import 'package:cocteles_app/features/cocktails/index_cocktails_page.dart';
import 'package:cocteles_app/features/cocktails/screens/create_cocktail_page.dart';
import 'package:cocteles_app/features/livestreams/screens/index_livestream_page.dart';
import 'package:cocteles_app/features/perzonalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocteles_app/features/createUser/screens/userProfile_page.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userCredentials = UserController.instance.userCredentials!;
    final controller = Get.put(NavigationController(userCredentials));

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: Colors.white,
          indicatorColor: Colors.deepOrange,
          destinations: controller.destinations,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final List<Widget> screens;
  final List<NavigationDestination> destinations;

  NavigationController(UserCredentials userCredentials)
      : screens = userCredentials.role == 'user'
            ? [
                IndexCocktailsPage(),
                IndexLivestreamPage(),
                ProfileScreen(),
              ]
            : [
                IndexCocktailsPage(),
                IndexLivestreamPage(),
                ProfileScreen(),
              ],
        destinations = userCredentials.role == 'user'
            ? [
                const NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  selectedIcon: Icon(Icons.home_filled),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.menu_book),
                  label: 'Recetas',
                  selectedIcon: Icon(Icons.menu_book),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.face),
                  label: 'Cuenta',
                  selectedIcon: Icon(Icons.face),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.menu_book),
                  label: 'Directos',
                  selectedIcon: Icon(Icons.menu_book),
                ),
                
              ]
            : [
                const NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  selectedIcon: Icon(Icons.home_filled),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.menu_book),
                  label: 'Recetas',
                  selectedIcon: Icon(Icons.menu_book),
                ),const NavigationDestination(
                  icon: Icon(Icons.face),
                  label: 'Cuenta',
                  selectedIcon: Icon(Icons.face),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.menu_book),
                  label: 'Directos',
                  selectedIcon: Icon(Icons.menu_book),
                ),
                const NavigationDestination(
                  icon: Icon(Icons.menu_book),
                  label: 'Revision',
                  selectedIcon: Icon(Icons.menu_book),
                ),
              ];
}
