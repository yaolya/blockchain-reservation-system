import 'package:application/pages/profile_page.dart';
import 'package:application/pages/search_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String id = '/HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _appBarTitle = [
    'Available for reservation',
    'Profile',
  ];
  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = const [
      SearchPage(),
      ProfilePage(),
    ];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle[_selectedPageIndex]),
      ),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: _pages,
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.blueGrey,
      items: _buildBottomNavBarItems(),
      currentIndex: _selectedPageIndex,
      onTap: (index) {
        setState(() {
          _selectedPageIndex = index;
          _pageController.jumpToPage(index);
        });
      },
    );
  }

  _buildBottomNavBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }
}
