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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // backgroundColor: AppColors.white,
        // selectedItemColor: AppColors.primary,
        // unselectedItemColor: AppColors.mediumGrey,
        // selectedLabelStyle: context.textTheme.titleSmall,
        // unselectedLabelStyle: context.textTheme.titleSmall,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
              size: _iconSize,
            ),
            activeIcon: const Icon(
              Icons.home,
              size: _iconSize,
            ),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
              size: _iconSize,
            ),
            activeIcon: const Icon(
              Icons.person,
              size: _iconSize,
            ),
            label: 'Mon profil',
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
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: const Icon(Icons.home),
                selectedIcon: const Icon(Icons.home),
                label: Text('Accueil'),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person),
                selectedIcon: const Icon(Icons.person),
                label: Text('Mon profil'),
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
