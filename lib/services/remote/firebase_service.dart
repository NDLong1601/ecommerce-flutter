import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../models/models.dart';

@LazySingleton()
class FirebaseService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseService(this._firebaseAuth, this._firebaseFirestore);

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      // Create user with email and password
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user info object
      final userInfo = UserInfoModel.createDefault(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      // Save user info to Firestore
      await _saveUserToFirestore(
        userId: userCredential.user!.uid,
        userInfo: userInfo,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An error occurred while creating account: ${e.toString()}';
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Save user info to Firestore
  Future<void> _saveUserToFirestore({
    required String userId,
    required UserInfoModel userInfo,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .set(userInfo.toJson());
  }

  /// Get user info from Firestore
  Future<UserInfoModel?> getUserInfo(String userId) async {
    try {
      final doc = await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return UserInfoModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user info: ${e.toString()}';
    }
  }

  /// Update user info in Firestore
  Future<void> updateUserInfo({
    required String userId,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': _parseDateOfBirth(dateOfBirth).toIso8601String(),
      };

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        updates['avatar_url'] = avatarUrl;
      }

      await _firebaseFirestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw 'Failed to update user info: ${e.toString()}';
    }
  }

  /// Parse date of birth from DD-MM-YYYY format to DateTime
  DateTime _parseDateOfBirth(String dateString) {
    try {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      throw FormatException('Invalid date format: $dateString');
    } catch (e) {
      throw FormatException('Invalid date format: $dateString');
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
}
