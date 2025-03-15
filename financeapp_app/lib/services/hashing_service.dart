import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class HashingService {

  /// Generates a random salt of given length (default 16 bytes) as a Base64 URL‑safe string.
  String generateSalt({int length = 16}) {
    final Random random = Random.secure();
    final List<int> saltBytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  /// Hashes the [key] concatenated with the [salt] using SHA‑256.
  String hashPin(String key, String salt) {
    final bytes = utf8.encode(key + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool verifyPin(String pin, String salt, String hash) {
    final String hashedPin = hashPin(pin, salt);
    return hashedPin == hash;
  }
}