import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kubera/dtos/auth_request.dart';
import 'package:kubera/dtos/user_details_dto.dart';
import 'package:kubera/services/assets_service.dart';
import 'package:kubera/services/hashing_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final HashingService _hashingService = HashingService();
  final AssetsService _assetsService = AssetsService();

  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  Future<void> loginAsync(AuthRequest dto) async {
    try{
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: dto.email, password: dto.password);
      
      // Save email to local storage to welcome the user back.
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', user.user?.email ?? '');

      // Clear caches
      _assetsService.clearAssetsCacheAsync();
    }

    catch (error) {
      rethrow;
    }
  }

  Future<void> registerAsync(AuthRequest dto) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: dto.email, password: dto.password);
    
      // Save email to local storage to welcome the user back.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', dto.email);

      // Clear caches
      await _assetsService.clearAssetsCacheAsync();
    }

    catch (error) {
      rethrow;
    }
  }

  Future<void> logoutAsync() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _assetsService.clearAssetsCacheAsync();
    }

    catch (error) {
      rethrow;
    }
  }

  Future<void> setPinAsync(String pin) async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not found');
      }

      // Hash and salt
      final String salt = _hashingService.generateSalt();
      final String hashedPin = _hashingService.hashPin(pin, salt);

      // Save the hashed pin and salt to the database
      final userDetails = UserDetails(pinHash: hashedPin, pinSalt: salt);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userDetails.toJson());
    }

    catch (e) {
      rethrow;
    }
  }

  Future<void> verifyPinAsync(String pin) async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not found');
      }

      // Get the user details
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!snapshot.exists) {
        throw Exception('User details not found');
      }

      final userDetails = UserDetails.fromJson(snapshot.data()!);
      if (!_hashingService.verifyPin(pin, userDetails.pinSalt, userDetails.pinHash)) {
        throw Exception('Invalid PIN');
      }
    }

    catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfPinExistsAsync() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not found');
      }

      // Get the user details
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!snapshot.exists) {
        return false;
      }

      final userDetails = UserDetails.fromJson(snapshot.data()!);
      return userDetails.pinHash.isNotEmpty;
    }

    catch (e) {
      rethrow;
    }
  }
}
