// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/smts_progress_model.dart';

import 'package:http/http.dart' as http;

class ApiService {
  static String API_SMTS_PROGRESS = dotenv.env['API_SMTS_PROGRESS']!;
  static Future<SmtsProgressModel> getSummertimeSagaProgress() async {
    final response = await http.get(Uri.parse(API_SMTS_PROGRESS));

    if (response.statusCode == 200) {
      SmtsProgressModel data = SmtsProgressModel.fromJson(response.body);
      return data;
    } else {
      throw Exception('Failed to load progress data');
    }
  }
}
