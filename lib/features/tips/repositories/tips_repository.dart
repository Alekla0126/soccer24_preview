import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/constants.dart';
import '../models/tip_like.dart';
import '../models/tip_model.dart';

class TipsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future saveTip(Tip tip) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('You are not logged in!');
    }

    try {
      final ref = _db
          .collection(Constants.tipsColName)
          .withConverter(
            fromFirestore: (snap, _) => Tip.fromFirestore(snap),
            toFirestore: (tip, _) => tip.toJson(),
          )
          .doc(tip.id);

      await ref.set(
        tip.copyWith(
          id: ref.id,
          uid: user.uid,
          authorName: user.displayName,
          authorPicture: user.photoURL,
        ),
      );
    } catch (_) {
      rethrow;
    }
  }

  Future deleteTip(String tipId) async {
    try {
      await _db.collection(Constants.tipsColName).doc(tipId).delete();
    } catch (_) {
      rethrow;
    }
  }

  Future deleteUserTips(String uid) async {
    try {
      await _db
          .collection(Constants.tipsColName)
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (final DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (_) {
      rethrow;
    }
  }

  Query<Tip> getFixtureTips(int fixtureId) {
    return _db
        .collection(Constants.tipsColName)
        .withConverter(
          fromFirestore: (snap, _) => Tip.fromFirestore(snap),
          toFirestore: (tip, _) => tip.toJson(),
        )
        .where('fixtureId', isEqualTo: fixtureId);
  }

  Query<Tip> getOwnTips() {
    if (_auth.currentUser == null) {
      throw Exception('You are not logged in!');
    }
    return _db
        .collection(Constants.tipsColName)
        .withConverter(
          fromFirestore: (snap, _) => Tip.fromFirestore(snap),
          toFirestore: (tip, _) => tip.toJson(),
        )
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .orderBy('shareTime', descending: true);
  }

  Query<Tip> getTips({
    int? from,
    int? to,
    int? leagueId,
    int? betId,
    bool descending = true,
  }) {
    Query<Tip> query = _db.collection(Constants.tipsColName).withConverter(
          fromFirestore: (snap, _) => Tip.fromFirestore(snap),
          toFirestore: (tip, _) => tip.toJson(),
        );

    if (from != null && to != null) {
      query = query
          .where('fixtureTimestamp', isGreaterThanOrEqualTo: from)
          .where('fixtureTimestamp', isLessThan: to - 60);
    }

    if (leagueId != null) {
      query = query.where('leagueId', isEqualTo: leagueId);
    }

    if (betId != null) {
      query = query.where('betId', isEqualTo: betId);
    }

    return query.orderBy('fixtureTimestamp', descending: true);
  }

  Stream<DocumentSnapshot<TipLike?>> checkLike(String tipId) {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('You are not logged in!');
    }
    return _db
        .collection(Constants.tipsColName)
        .doc(tipId)
        .collection(Constants.tipsLikesColName)
        .withConverter(
          fromFirestore: (snap, _) => TipLike.fromFirestore(snap),
          toFirestore: (tip, _) => tip.toJson(),
        )
        .doc(uid)
        .snapshots();
  }

  Future updateLikes({
    required String tipId,
    required bool isLike,
    required bool delete,
    required bool switchLikes,
  }) async {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('You are not logged in!');
    }

    final DocumentReference<Tip> tipRef = _db
        .collection(Constants.tipsColName)
        .withConverter(
          fromFirestore: (snap, _) => Tip.fromFirestore(snap),
          toFirestore: (tip, _) => tip.toJson(),
        )
        .doc(tipId);
    final likeRef = tipRef.collection(Constants.tipsLikesColName).doc(uid);

    try {
      await _db.runTransaction((transaction) async {
        final DocumentSnapshot<Tip> snapshot = await transaction.get(tipRef);

        if (!snapshot.exists) {
          throw Exception('Tip does not exist!');
        }

        int newLikes = snapshot.data()!.likes;
        int newDislikes = snapshot.data()!.dislikes;

        if (switchLikes && !delete) {
          if (isLike) {
            newLikes += 1;
            newDislikes -= 1;
          } else {
            newLikes -= 1;
            newDislikes += 1;
          }
        } else {
          if (isLike) {
            newLikes = delete ? newLikes - 1 : newLikes + 1;
          } else {
            newDislikes = delete ? newDislikes - 1 : newDislikes + 1;
          }
        }

        transaction.update(tipRef, {
          'likes': newLikes < 0 ? 0 : newLikes,
          'dislikes': newDislikes < 0 ? 0 : newDislikes,
        });
      }).then((_) async {
        try {
          if (delete) {
            await likeRef.delete();
          } else {
            await likeRef.set(TipLike(userId: uid, isLiked: isLike).toJson());
          }
        } catch (_) {
          rethrow;
        }
      });
    } catch (_) {
      rethrow;
    }
  }
}
