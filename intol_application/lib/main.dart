import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intol_application/firebase_options.dart';
import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/questionnaire_page.dart';
import 'pages/home_page.dart';
import 'pages/redirection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intol App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/redirect': (context) => const RedirectionPage(),
        '/login': (context) => LoginPage(title: "Se connecter",),
        '/register': (context) => RegisterPage(),
        '/questionnaire': (context) => QuestionnairePage(),
        '/home': (context) => const HomePage(title: "Accueil",),
      },
    );
  }
}
