import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_state.dart';
import '../pages/panel1.dart';
import '../pages/panel2.dart';
import '../pages/panel3.dart';
import '../pages/panel4.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Panel1();
        break;
      case 1:
        page = Panel2();
        break;
      case 2:
        page = Panel3();
        break;
      case 3:
        page = Panel4();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    backgroundColor: colorScheme.surfaceContainerLowest,
                    selectedItemColor: colorScheme.primary,
                    unselectedItemColor: colorScheme.onSurfaceVariant,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu_book),
                        label: 'Recetas',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.videocam),
                        label: 'Directos',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Perfil',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bar_chart),
                        label: 'Estadisticas',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 1200,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.menu_book),
                        label: Text('Recetas'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.videocam),
                        label: Text('Directos'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person),
                        label: Text('Perfil'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bar_chart),
                        label: Text('Estadisticas'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
