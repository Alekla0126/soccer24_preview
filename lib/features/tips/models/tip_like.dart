import 'package:cloud_firestore/cloud_firestore.dart';

class TipLike {
  final String userId;
  final bool isLiked;

  TipLike({
    required this.userId,
    required this.isLiked,
  });

  factory TipLike.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return TipLike.fromJson(snapshot.data() ?? {});
  }

  factory TipLike.fromJson(Map<String, dynamic> json) {
    return TipLike(userId: json['userId'], isLiked: json['isLiked']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isLiked': isLiked,
    };
  }
}