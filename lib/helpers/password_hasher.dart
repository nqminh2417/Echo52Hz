import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

class Argon2Hasher {
  static final Argon2id _argon2 = Argon2id(
    parallelism: 2,
    memory: 65536, // 64MB
    iterations: 3, hashLength: 16,
  );

  static Future<String> hashPassword(String password) async {
    final salt = _generateSalt();
    final passwordBytes = utf8.encode(password);
    final secretKey = SecretKey(passwordBytes);

    final hash = await _argon2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );

    final saltBase64 = base64.encode(salt);
    final hashBase64 = base64.encode(hash.extractBytes(secretKey));
    return '$saltBase64:$hashBase64';
  }

  static Future<bool> verifyPassword(String password, String saltedHash) async {
    final parts = saltedHash.split(':');
    if (parts.length != 2) {
      return false;
    }

    final saltBase64 = parts[0];
    final hashBase64 = parts[1];
    final salt = base64.decode(saltBase64);
    final storedHash = base64.decode(hashBase64);

    final passwordBytes = utf8.encode(password);
    final secretKey = SecretKey(passwordBytes);

    final hash = await _argon2.deriveKey(
      secretKey: secretKey,
      nonce: salt,
    );

    return _constantTimeComparison(storedHash, hash.bytes);
  }

  static List<int> _generateSalt() {
    final Random rng = Random.secure();
    return List<int>.generate(16, (_) => rng.nextInt(256));
  }

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
