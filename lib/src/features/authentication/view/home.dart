import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../widgets/bottom_nav_bar.dart';
import '../../../widgets/title.dart';
import '../../jobs/jobs.dart';
import '../../user/user.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const _HomePage(),
    const ListJob(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.split(' ').firstOrNull ?? '';

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitle(text: "Bienvenue $displayName"),
                const SizedBox(height: 16),
                Text(
                  "Découvrez les dernières opportunités",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(child: ListJob(showAppBar: false)),
        ],
      ),
    );
  }
}
