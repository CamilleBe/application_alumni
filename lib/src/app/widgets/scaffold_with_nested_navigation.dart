import 'package:ekod_alumni/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, __) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          onTap: _goBranch,
          currentIndex: navigationShell.currentIndex,
        );
      },
      large: (_, __) {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          onDestinationSelected: _goBranch,
          currentIndex: navigationShell.currentIndex,
        );
      },
    );
  }
}

const _iconSize = 28.0;

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    required this.body,
    required this.onTap,
    required this.currentIndex,
    super.key,
  });

  final Widget body;
  final ValueChanged<int> onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE53E3E),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: _iconSize,
            ),
            activeIcon: Icon(
              Icons.home,
              size: _iconSize,
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_outline,
              size: _iconSize,
            ),
            activeIcon: Icon(
              Icons.people,
              size: _iconSize,
            ),
            label: 'Alumni',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: _iconSize,
            ),
            activeIcon: Icon(
              Icons.person,
              size: _iconSize,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    required this.body,
    required this.onDestinationSelected,
    required this.currentIndex,
    super.key,
  });

  final Widget body;
  final ValueChanged<int> onDestinationSelected;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            selectedIconTheme: const IconThemeData(
              color: Color(0xFFE53E3E),
            ),
            selectedLabelTextStyle: const TextStyle(
              color: Color(0xFFE53E3E),
              fontWeight: FontWeight.w600,
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Accueil'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Alumni'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Profil'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content
          Expanded(child: body),
        ],
      ),
    );
  }
}
