import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:intol_application/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var logger = Logger();

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login classique
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Création d’un compte + création Firestore avec nom
  Future<void> createUserWithEmailAndPassword(String email, String password, String name) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      await _createOrUpdateUserData(user, name: name); // 👈 ajout du nom dans Firestore
    }
  }

  // Déconnexion
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Connexion avec Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Créer ou mettre à jour l’utilisateur dans Firestore
      await _createOrUpdateUserData(userCredential.user!);

      return userCredential;
    } catch (e) {
      logger.e('Erreur Google Sign-In: $e');
      return null;
    }
  }

  // Crée ou met à jour les données Firestore de l'utilisateur
  Future<void> _createOrUpdateUserData(User user, {String? name, List<String>? intolerances}) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final data = {
      'email': user.email,
      if (name != null) 'name': name,
      if (intolerances != null) 'intolerances': intolerances,
    };

    await docRef.set(data, SetOptions(merge: true));
  }

  // Appel public si tu veux mettre à jour le nom depuis un formulaire
  Future<void> updateUserName(String uid, String name) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'name': name});
  }

  // Mettre à jour les intolérances (ex: après questionnaire)
  Future<void> updateUserIntolerances(String uid, List<String> intolerances) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'intolerances': intolerances});
  }

  // Charger les données utilisateur (email, nom, intolérances)
  Future<AppUser?> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data()!, uid: uid);
    }
    return null;
  }
}
