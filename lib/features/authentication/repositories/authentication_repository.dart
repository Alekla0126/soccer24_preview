import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../constants/constants.dart';
import '../../tips/repositories/tips_repository.dart';
import '../auth_exception.dart';
import '../models/user_model.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  BSUser currentUser = BSUser.empty;

  Stream<BSUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      currentUser = firebaseUser == null
          ? BSUser.empty
          : BSUser(
              uid: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email,
              photoURL: firebaseUser.photoURL,
            );

      return currentUser;
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('AppAuthentication => Code: ${e.code} - Message: ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('AppAuthentication => $e');
      throw AuthException.signInFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      await _saveUserOnceCreated();
    } on FirebaseAuthException catch (e) {
      debugPrint('AppAuthentication => Code: ${e.code} - Message: ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('AppAuthentication => $e');
      throw AuthException.signInWithGoogleFailure();
    }
  }

  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
      await _saveUserOnceCreated();
    } on FirebaseAuthException catch (e) {
      debugPrint('AppAuthentication => Code: ${e.code} - Message: ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('AppAuthentication => $e');
      throw AuthException.signInAnonymouslyFailure();
    }
  }

  Future<void> signUpWithEmailEndPassword({
    required String? name,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        if (user.displayName == null) {
          await user.updateDisplayName(name);
          await user.reload();
        }

        //Save user to firestore
        if (name != null) {
          await Future.delayed(
            const Duration(seconds: 1),
            () {
              _saveUserOnceCreated(name);
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('AppAuthentication => Code: ${e.code} - Message: ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('AppAuthentication => $e');
      throw AuthException.signUpFailure();
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('AppAuthentication => $e');
      throw AuthException.logoutFailure();
    }
  }

  Future<void> verifyUserEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    final uid = user.uid;
    try {
      Future.wait([
        _userCollectionRef.doc(uid).delete(),
        TipsRepository().deleteUserTips(uid),
        user.delete()
      ]);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    } catch (e) {
      throw AuthException.deleteAccountFailure();
    }
  }

  Future<void> signInWithApple() async {
    try {
      // Request credentials from Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // Create OAuth credentials for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      // Sign in to Firebase
      await _firebaseAuth.signInWithCredential(oauthCredential);
      await _saveUserOnceCreated(appleCredential.givenName);
    } on FirebaseAuthException catch (e) {
      debugPrint('AppAuthentication => Code: ${e.code} - Message: ${e.message}');
      throw AuthException.fromCode(e.code);
    } catch (e) {
      debugPrint('AppAuthentication => $e');
      throw AuthException.signInWithAppleFailure();
    }
  }

  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection(Constants.usersColName);

  Future _saveUser([String? name]) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      if (user.displayName == null) {
        await _firebaseAuth.currentUser!.updateDisplayName(name);
        await _firebaseAuth.currentUser!.reload();
      }
      user = _firebaseAuth.currentUser!;
      currentUser = BSUser(
        uid: user.uid,
        name: name ?? user.displayName,
        email: user.email,
        photoURL: user.photoURL,
        joinedAt: Timestamp.now(),
        emailVerified: user.emailVerified,
      );
    }
    await _userCollectionRef
        .withConverter<BSUser>(
          fromFirestore: (snap, options) => BSUser.fromFirestore(snap),
          toFirestore: (u, _) => u.toJson(),
        )
        .doc(currentUser.uid)
        .set(currentUser);
  }

  Future _saveUserOnceCreated([String? name]) async {
    final metadata = _firebaseAuth.currentUser?.metadata;

    if (metadata == null) return;

    final int creationTime = metadata.creationTime!.millisecondsSinceEpoch ~/ 1000;
    final int lastSignInTime = metadata.lastSignInTime!.millisecondsSinceEpoch ~/ 1000;

    if ((creationTime - lastSignInTime).abs() < 5) {
      await _saveUser(name);
    }
  }
}
