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
            const Header(title: 'Welcome', subtitle: 'Scan. Detect. Stay Safe.'),
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
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                'https://readdy.ai/api/search-image?query=icon%2C%203D%20cartoon%20healthy%20food%20scanner%20app%20symbol%2C%20vibrant%20colors%20with%20soft%20gradients%2C%20minimalist%20design%2C%20smooth%20rounded%20shapes%2C%20subtle%20shading%2C%20no%20outlines%2C%20centered%20composition%2C%20isolated%20on%20white%20background%2C%20playful%20and%20friendly%20aesthetic%2C%20isometric%20perspective%2C%20high%20detail%20quality%2C%20clean%20and%20modern%20look%2C%20single%20object%20focus%2C%20the%20icon%20should%20take%20up%2070%25%20of%20the%20frame&width=200&height=200&seq=home-hero&orientation=squarish',
                                width: 96,
                                height: 96,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Take Control of Your Health',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Scan any product barcode to instantly check if it contains ingredients you're intolerant to. Your health companion is here!",
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
                      children: const [
                        FeatureTile(icon: Icons.qr_code_scanner, color1: Colors.green, color2: Colors.teal, title: 'Quick Scan', subtitle: 'Instant barcode recognition'),
                        FeatureTile(icon: Icons.shield, color1: Colors.orange, color2: Colors.red, title: 'Safe Check', subtitle: 'Personalized alerts'),
                        FeatureTile(icon: Icons.history, color1: Colors.purple, color2: Colors.pink, title: 'History', subtitle: 'Track your scans'),
                        FeatureTile(icon: Icons.favorite, color1: Colors.blue, color2: Colors.indigo, title: 'Profile', subtitle: 'Manage intolerances'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Health Tip
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
                                Text('Health Tip', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                                SizedBox(height: 4),
                                Text(
                                  'Always read ingredient labels carefully. Hidden allergens can be found in unexpected places!',
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

  const FeatureTile({
    super.key,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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



