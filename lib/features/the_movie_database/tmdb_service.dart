import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/string_utils.dart';

class TmdbService {
  static const _apiKeyKey = 'TMDB_API_KEY';
  static const _apiReadAccessTokenKey = 'TMDB_API_READ_ACCESS_TOKEN';

  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';

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

  static Future<List<dynamic>> fetchTrendingMovies() async {
    final apiKey = await getApiKey();
    final url = Uri.parse('$tmdbBaseUrl/trending/movie/day?api_key=$apiKey&language=vi-VI');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> movies = data['results'];
      return movies;
    } else {
      StringUtils.debugLog('Error fetching trending movies: ${response.statusCode}');
      return [];
    }
  }
}
