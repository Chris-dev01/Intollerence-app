import 'package:firebase_auth/firebase_auth.dart';
import 'package:intol_application/services/firebase/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _forLogin = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
  body: Stack(
    fit: StackFit.expand,
    children: [
      Image.asset(
        'assets/images/background.jpeg',
        fit: BoxFit.cover,
      ),

      Container(
        color: Colors.white.withOpacity(0.3),
      ),

      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
          
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo3.png', height: 90),
                  const SizedBox(height: 20),
                  Text(
                    _forLogin ? "Connexion" : "Créer un compte",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!_forLogin)
                    _glassInput("Nom", _nameController, Icons.person),
                  if (!_forLogin) const SizedBox(height: 20),
                  _glassInput("Email", _emailController, Icons.email),
                  const SizedBox(height: 20),
                  _glassInput("Mot de passe", _passwordController, Icons.lock, isPassword: true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(_forLogin ? "Se connecter" : "S'inscrire",
                              style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() => _forLogin = !_forLogin);
                    },
                    child: Text(
                      _forLogin
                          ? "Je n'ai pas de compte, m'inscrire"
                          : "J'ai déjà un compte, me connecter",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Divider(color: Colors.white38),
                  ElevatedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    icon: Image.asset("assets/images/Google.png", height: 35),
                    label: const Text("Continuer avec Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ],
  ),
);
  }


  Future<void> _handleGoogleSignIn() async {
  setState(() => _isLoading = true);

  try {
    final result = await Auth().signInWithGoogle();

    if (result != null) {
      Navigator.pushReplacementNamed(context, '/questionnaire'); // ou '/home'
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connexion Google annulée."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    logger.e("Erreur Google Sign-In: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Erreur Google Sign-In: $e"),
        backgroundColor: Colors.redAccent,
      ),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}




  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_forLogin) {
          await Auth().loginWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
        } else {
          await Auth().createUserWithEmailAndPassword(
            _emailController.text,
            _passwordController.text,
          );
        }

      // Navigation selon le cas
      if (_forLogin) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/questionnaire');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Une erreur est survenue'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}



Widget _glassInput(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    validator: (value) => value == null || value.isEmpty ? '$label requis' : null,
  );
}





