import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';
import 'storage_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> login(
    String email,
    String password
  ) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password
    );
  }

  Future<void> logout() {
    return _firebaseAuth.signOut();
  }

  Future<void> register(
    String username,
    String email,
    String password
  ) async {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
    return _firestore
      .collection('users')
      .doc(authResult.user?.uid)
      .set({
        'username': username,
        'email': email,
        'searchTerms': _getSearchTermsByString(username),
        'postsCount': 0,
        'followersCount': 0,
        'followingCount': 0,
        'date': DateTime.now()
      });
  }

  Future<void> resetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateProfile(
    String userName,
    String password,
    String imagePath,
    File? imageFile
  ) async {
    if (password.isNotEmpty) {
      await _firebaseAuth.currentUser!.updatePassword(password);
    }
    if (imagePath.isNotEmpty && (imageFile != null)) {
      await StorageService.removeFile(imagePath);
    }
    Map<String, Object?> userData = {
      'username': userName,
      'searchTerms': _getSearchTermsByString(userName),
      'date': DateTime.now()
    };
    String currentUserId = FirebaseService.getCurrentUserId();
    if (imageFile != null) {
      StorageFile newImageFile = await StorageService.saveFile(
        imageFile,
        'users/$currentUserId${DateTime.now().millisecondsSinceEpoch}.jpg'
      );
      userData['imageUrl'] = newImageFile.url;
      userData['imagePath'] = newImageFile.path;
    }
    return _firestore
      .collection('users')
      .doc(currentUserId)
      .update(userData);
  }

  List<String> _getSearchTermsByString(String source) {
    source = source.trim().toLowerCase();
    List<String> longTerms = source
      .split(' ')
      .toList();
    List<String> shortTerms = [];
    if (longTerms.length > 1) {
      shortTerms.add(source);
    }
    for (String longTerm in longTerms) {
      for (int i = 0; i < longTerm.length; i++) {
        shortTerms.add(longTerm.substring(0, i + 1));
      }
      for (int i = (longTerm.length - 1); i > 0; i--) {
        shortTerms.add(longTerm.substring(i, longTerm.length));
      }
    }
    return shortTerms;
  }
}