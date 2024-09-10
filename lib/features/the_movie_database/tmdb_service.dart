import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TmdbService {
  static const _apiKeyKey = 'TMDB_API_KEY';
  static const _apiReadAccessTokenKey = 'TMDB_API_READ_ACCESS_TOKEN';

  static const _storage = FlutterSecureStorage();

  static Future<String> getApiKey() async {
    final apiKey = await _storage.read(key: _apiKeyKey);
    return apiKey ?? '';
  }

  static Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyKey, value: apiKey);
  }

  static Future<String> getApiReadAccessToken() async {
    final apiReadAccessToken = await _storage.read(key: _apiReadAccessTokenKey);
    return apiReadAccessToken ?? '';
  }

  static Future<void> saveApiReadAccessToken(String apiReadAccessToken) async {
    await _storage.write(key: _apiReadAccessTokenKey, value: apiReadAccessToken);
  }
}
