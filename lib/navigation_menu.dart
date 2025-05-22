import 'package:cocteles_app/features/authentication/models/user_credentials.dart';
import 'package:cocteles_app/features/authentication/screens/login_page.dart';
import 'package:cocteles_app/features/cocktails/index_cocktails_page.dart';
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
          onDestinationSelected: (index) {
            final label = controller.destinations[index].label;
            if (label == 'Salir') {
              controller.logout();
            } else {
              controller.selectedIndex.value = index;
            }
          },
          backgroundColor: Colors.white,
          indicatorColor: const Color.fromARGB(255, 232, 164, 143),
          destinations: controller.destinations,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late final List<Widget> screens;
  late final List<NavigationDestination> destinations;

  NavigationController(UserCredentials userCredentials) {
    if (userCredentials.role == 'user') {
      screens = [
        PlaceholderScreen(title: 'Home'), 
        IndexCocktailsPage(),             
        ProfileScreen(),                  
        IndexLivestreamPage(),            
        LogoutScreen(),                   
      ];

      destinations = [
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
          icon: Icon(Icons.live_tv),
          label: 'Directos',
          selectedIcon: Icon(Icons.live_tv),
        ),
        const NavigationDestination(
          icon: Icon(Icons.logout),
          label: 'Salir',
          selectedIcon: Icon(Icons.logout),
        ),
      ];
    } else {
      screens = [
        PlaceholderScreen(title: 'Home'), 
        IndexCocktailsPage(),             
        ProfileScreen(),                  
        IndexLivestreamPage(),            
        ProfileScreen(),                  
        LogoutScreen(),                   
      ];

      destinations = [
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
          icon: Icon(Icons.live_tv),
          label: 'Directos',
          selectedIcon: Icon(Icons.live_tv),
        ),
        const NavigationDestination(
          icon: Icon(Icons.rate_review),
          label: 'Revision',
          selectedIcon: Icon(Icons.rate_review),
        ),
        const NavigationDestination(
          icon: Icon(Icons.logout),
          label: 'Salir',
          selectedIcon: Icon(Icons.logout),
        ),
      ];
    }
  }

  void logout() {
    Get.offAll(() => const LoginPage());
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Pantalla $title'));
  }
}

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Saliendo...'),
    );
  }
}
