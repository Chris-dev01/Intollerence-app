import 'package:flutter/material.dart';
import 'package:intol_application/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intol_application/pages/accueil_page.dart';
import 'package:intol_application/pages/scanner_page.dart';
import 'package:intol_application/pages/profile_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final User? user = Auth().currentUser;

  final Duration _animationDuration = const Duration(milliseconds: 400);
  final List<String> _titles = ["Accueil", "Scanner", "Profil"];

  @override
  Widget build(BuildContext context) {
  final List<Widget> pages = [
    const AccueilPage(),
    ScannerPage(onCodeScanned: _handleBarcodeScanned),
    ProfilePage(user: user),
  ];


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Auth().logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: _animationDuration,
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: Container(
          key: ValueKey<int>(_currentIndex),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe0f7fa), Color(0xFF80deea)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: pages[_currentIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF009688),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scanner",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  void _handleBarcodeScanned(String code) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Code scanné"),
      content: Text(code),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

}

