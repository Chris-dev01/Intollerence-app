// lib/pages/accueil_page.dart
import 'package:flutter/material.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Column(
          children: [
            //const Header(title: 'Bienvenue', subtitle: 'Scannez. Détectez. Restez en sécurité.'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  children: [
                    // Hero section
                    Column(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                'assets/images/logo.png',
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Prenez le contrôle de votre santé',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Scannez le code-barres de n'importe quel produit pour vérifier instantanément s'il contient des ingrédients auxquels vous êtes intolérant. Votre compagnon de santé est ici !",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Features Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        FeatureTile(
                          icon: Icons.qr_code_scanner,
                          color1: Colors.green, 
                          color2: Colors.teal, 
                          title: 'Scan', 
                          subtitle: 'Reconnaissance des codes-barres', 
                          onTap: () {
                            Navigator.pushNamed(context, '/scanner');
                          },
                        ),
                        FeatureTile(
                          icon: Icons.history,
                          color1: Colors.purple,
                          color2: Colors.pink,
                          title: 'Historique',
                          subtitle: 'Suivez vos scans',
                          onTap: () {
                            Navigator.pushNamed(context, '/questionnaire');
                          },
                        ),
                        FeatureTile(
                          icon: Icons.favorite,
                          color1: Colors.blue,
                          color2: Colors.indigo,
                          title: 'Profile',
                          subtitle: 'Gérer les intolérances',
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                      ],

                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.yellow, Colors.orange]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.lightbulb, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Conseil santé', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                SizedBox(height: 4),
                                Text(
                                  'Lisez toujours attentivement les étiquettes des ingrédients. Des allergènes cachés peuvent se trouver dans des endroits inattendus !',
                                  style: TextStyle(color: Colors.black54, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final Color color1;
  final Color color2;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color1, color2]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
      ),
    );
  }
}

// Dummy Header and Navigation to avoid missing references.
class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const Header({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }
}



