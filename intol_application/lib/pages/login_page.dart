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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCCE5E1), Color(0xFFF2F7F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  // Logo
                  Image.asset(
                    'lib/images/logo3.png',
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _forLogin ? "Connexion" : "Créer un compte",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Nom (si inscription)
                  if (!_forLogin)
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Nom", Icons.person),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Nom requis' : null,
                    ),

                  if (!_forLogin) const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email", Icons.email),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Email requis' : null,
                  ),
                  const SizedBox(height: 20),

                  // Mot de passe
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Mot de passe", Icons.lock),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Mot de passe requis' : null,
                  ),
                  const SizedBox(height: 30),

                  // Bouton
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

                  // Lien bas
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _forLogin = !_forLogin;
                      });
                    },
                    child: Text(
                      _forLogin
                          ? "Je n'ai pas de compte, m'inscrire"
                          : "J'ai déjà un compte, me connecter",
                      style: TextStyle(color: Colors.teal[700]),
                    ),
                  ),

                  const Divider(),

                  ElevatedButton.icon(
                    onPressed: (){},
                    icon: Image.asset("lib/images/Google.png", height: 35,),
                    label : const Text("Continue with Google")
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal),
      ),
    );
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















/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Image.asset(
            'lib/images/background.jpeg',
            fit: BoxFit.cover,
          ),

          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                              activeColor: Colors.blue,
                            ),
                            const Text("Remember me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                         /* TextStyle(
                          color: Colors.black),*/
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text("Sign in with"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



*/