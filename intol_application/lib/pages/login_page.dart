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
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _forLogin = true;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 242, 246, 255), Color.fromARGB(255, 242, 246, 255)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo3.png', height: 90),
                    const Text(
                      'Intol',
                      style: TextStyle(fontFamily: 'Pacifico', fontSize: 24),
                    ),
                    const SizedBox(height: 24),
                    Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _forLogin = true),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: _forLogin ? Color.fromARGB(255, 59, 131, 246) : Colors.white ,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Se Connecter',
                                  style: TextStyle(
                                    color: _forLogin ?   Colors.white : Color.fromARGB(255, 59, 131, 246) ,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _forLogin = false),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !_forLogin ?  Color.fromARGB(255, 59, 131, 246) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'S\'inscrire',
                                  style: TextStyle(
                                    color: !_forLogin ? Colors.white : Color.fromARGB(255, 59, 131, 246),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                    const SizedBox(height: 30),
                    if (!_forLogin)
                      _glassInput("Nom", _nameController, Icons.person),
                    if (!_forLogin) const SizedBox(height: 20),
                    _glassInput("Email", _emailController, Icons.email),
                    const SizedBox(height: 20),
                    _glassInput("Mot de passe", _passwordController, Icons.lock, isPassword: true),
                    const SizedBox(height: 20),
                    if (!_forLogin)
                      _glassInput("Confirmer le mot de passe", _confirmPasswordController, Icons.lock, isPassword: true, isConfirm: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _submitForm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 59, 131, 246), Color.fromARGB(255, 8, 181, 150)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    _forLogin ? "Se connecter" : "S'inscrire",
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color.fromARGB(255, 122, 122, 122)),
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
        Navigator.pushReplacementNamed(context, '/questionnaire');
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

    if (!_forLogin && _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les mots de passe ne correspondent pas."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_forLogin) {
        await Auth().loginWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await Auth().createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
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


  Widget _glassInput(String label, TextEditingController controller, IconData icon, {bool isPassword = false, bool isConfirm = false}) {
  bool isVisible = isConfirm ? _confirmPasswordVisible : _passwordVisible;

  return TextFormField(
    controller: controller,
    obscureText: isPassword ? !isVisible : false,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 168, 166, 166)),
      prefixIcon: Icon(icon, color: Color.fromARGB(255, 168, 166, 166)),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color.fromARGB(255, 168, 166, 166),
              ),
              onPressed: () {
                setState(() {
                  if (isConfirm) {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  } else {
                    _passwordVisible = !_passwordVisible;
                  }
                });
              },
            )
          : null,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
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

}

