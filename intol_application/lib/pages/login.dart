
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intol_application/services/firebase/auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child : Form(
          key: _formKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Email",
                border:OutlineInputBorder()
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Email is required';
                }else{
                  return null;
                }
              },
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText:"Password",
                border: OutlineInputBorder()
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Password is required';
                }else{
                  return null;
                }
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    try{
                      await Auth().loginWithEmailAndPassword(_emailController.text, _passwordController.text);
                    } on FirebaseAuthException catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content:Text("${e.message}"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.purple,
                        showCloseIcon: true,
                        ),);
                    }
                  }
                },
                child: const Text("Se Connecter")
                ),
            ),
          ],
      ),
        ),
      ),
      );
    
  }
}