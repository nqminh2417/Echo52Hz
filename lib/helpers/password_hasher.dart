import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart';

class PasswordHasher {
  static final PBKDF2KeyDerivator _derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
  static const int _saltLength = 16;
  static const int _iterationCount = 10000;
  static const int _derivedKeyLength = 32;

  // Method to hash the password with a new salt
  static Future<String> hashPassword(String password) async {
    final salt = _generateSalt();
    final passwordBytes = utf8.encode(password);
    final params = Pbkdf2Parameters(Uint8List.fromList(salt), _iterationCount, _derivedKeyLength);

    _derivator.init(params);
    final derivedKey = _derivator.process(Uint8List.fromList(passwordBytes));

    final saltBase64 = base64.encode(salt);
    final hashBase64 = base64.encode(derivedKey);
    return '$saltBase64:$hashBase64';
  }

  // Method to verify the password against the stored hash
  static bool verifyPassword(String password, String saltedHash) {
    final parts = saltedHash.split(':');
    if (parts.length != 2) {
      return false;
    }

    final saltBase64 = parts[0];
    final hashBase64 = parts[1];
    final salt = base64.decode(saltBase64);
    final storedHash = base64.decode(hashBase64);

    final passwordBytes = utf8.encode(password);
    final params = Pbkdf2Parameters(Uint8List.fromList(salt), _iterationCount, _derivedKeyLength);

    _derivator.init(params);
    final derivedKey = _derivator.process(Uint8List.fromList(passwordBytes));

    return _constantTimeComparison(storedHash, derivedKey);
  }

  // Helper method to generate a new salt
  static List<int> _generateSalt() {
    final rng = Random.secure();
    return List<int>.generate(_saltLength, (_) => rng.nextInt(256));
  }

  // Helper method to compare two byte lists in constant time
  static bool _constantTimeComparison(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
