class AppUser {
  final String uid;
  final String? email;
  final String? name;
  final List<String>? intolerances;

  AppUser({
    required this.uid,
    this.email,
    this.name,
    this.intolerances,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, {required String uid}) {
    return AppUser(
      uid: uid,
      email: map['email'],
      name: map['name'],
      intolerances: List<String>.from(map['intolerances'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'intolerances': intolerances,
    };
  }
}
