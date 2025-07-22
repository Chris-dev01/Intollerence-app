import 'package:flutter/material.dart';
import 'package:intol_application/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


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
      _buildWelcomePage(),
      _buildScannerPage(),
      _buildProfilePage(),
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
        selectedItemColor: Colors.teal,
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

  Widget _buildWelcomePage() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.health_and_safety, size: 80, color: Colors.teal),
              SizedBox(height: 20),
              Text(
                "Bienvenue dans IntolScan !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Scannez, identifiez vos intolérances, restez en bonne santé.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildScannerPage() {
  return Stack(
    children: [
      MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              debugPrint('Code scanné: $code');
              
              _handleBarcodeScanned(code);
              break;
            }
          }
        },
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 80),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Scannez un code-barres",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildProfilePage() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.teal),
              const SizedBox(height: 10),
              Text(
                user?.email ?? 'Utilisateur inconnu',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _handleBarcodeScanned(String code) {
  // 👉 Empêche les scans multiples
  if (!mounted) return;
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Code scanné'),
      content: Text('Valeur : $code'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );

  // 👉 Tu peux ici envoyer le `code` vers Firestore, Supabase ou une API
}

}

