import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BSUser extends Equatable {
  final String uid;
  final String? email;
  final bool emailVerified;
  final String? name;
  final String? photoURL;
  final Timestamp? joinedAt;

  const BSUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
    this.name,
    this.photoURL,
    this.joinedAt,
  });

  static const empty = BSUser(uid: '');

  bool get isEmpty => uid.isEmpty;

  bool get isNotEmpty => uid.isNotEmpty;

  factory BSUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final Map<String, dynamic>? map = snapshot.data();
    return map != null ? BSUser.fromMap(map) : BSUser.empty;
  }

  factory BSUser.fromMap(Map<String, dynamic> map) {
    return BSUser(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      emailVerified: map['emailVerified'],
      photoURL: map['photoURL'],
      joinedAt: map['joinedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'emailVerified': emailVerified,
      'photoURL': photoURL,
      'joinedAt': joinedAt,
    };
  }

  @override
  List<Object?> get props => [uid];
}
