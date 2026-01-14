import 'package:fhgfgfggh/shoppingcart/frontpage.dart';
import 'package:fhgfgfggh/shoppingcart/profile.dart';
import 'package:provider/provider.dart';
import 'package:fhgfgfggh/shoppingcart/cartprovider.dart';
import 'package:fhgfgfggh/shoppingcart/search.dart';
import 'package:flutter/material.dart';

import 'favourites.dart';

class Subfrontpage extends StatefulWidget {
  const Subfrontpage({super.key});

  @override
  State<Subfrontpage> createState() => _SubfrontpageState();
}

class _SubfrontpageState extends State<Subfrontpage> {
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      Frontpage(),
      Search(),
      Favourites(),
      Profile(isEditable: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<AppState>().selectedIndex;

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: DefaultTabController(
        length: 4,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (selectedIndex) {
            context.read<AppState>().setTab(selectedIndex);
          },
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black87,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
