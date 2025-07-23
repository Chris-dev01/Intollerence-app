import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

    if (!isLogin && password != confirmPassword) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    final user = {
      'email': email,
      'name': name.isEmpty ? 'User' : name,
    };

    final prefs = null;
    await prefs.setString('user', jsonEncode(user));

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> handleGoogleAuth() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final prefs = null;
    await prefs.setString(
      'user',
      jsonEncode({'email': 'user@gmail.com', 'name': 'Google User'}),
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4FE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  'https://readdy.ai/api/search-image?query=icon%2C%203D%20cartoon%20healthy%20food%20scanner%20app%20symbol%2C%20vibrant%20colors%20with%20soft%20gradients...etc',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FoodScan',
                style: TextStyle(fontFamily: 'Pacifico', fontSize: 24),
              ),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [isLogin, !isLogin],
                onPressed: (int index) {
                  setState(() {
                    isLogin = index == 0;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                selectedColor: Colors.white,
                fillColor: Colors.blue,
                color: Colors.black54,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: Text('Sign In'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                        ),
                        onSaved: (val) => name = val ?? '',
                        validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
                      ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => email = val ?? '',
                      validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      ),
                      onSaved: (val) => password = val ?? '',
                      validator: (val) => val == null || val.length < 6 ? 'Password too short' : null,
                    ),
                    if (!isLogin) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        obscureText: !showConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(showConfirmPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                          ),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                        ),
                        onSaved: (val) => confirmPassword = val ?? '',
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Icon(isLogin ? Icons.login : Icons.person_add),
                      label: Text(isLogin ? 'Sign In' : 'Create Account'),
                      onPressed: isLoading ? null : handleSubmit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Or continue with'),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Image.network(
                  'https://readdy.ai/api/search-image?query=icon%2C%20Google%20logo%2C%20...',
                  width: 20,
                  height: 20,
                ),
                label: const Text('Continue with Google'),
                onPressed: isLoading ? null : handleGoogleAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: const Text('Continue with Facebook'),
                onPressed: isLoading ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
