import 'package:flutter/material.dart';
import 'package:intol_application/pages/login_page.dart';
import 'package:intol_application/pages/home_page.dart';
import 'package:intol_application/services/firebase/auth.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});

  @override
  State<RedirectionPage> createState() => _RedirectionPageState();
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const HomePage(title: "Accueil");
        } else {
          return LoginPage(title:"Se connecter");
        }
      },
    );
  }
}
