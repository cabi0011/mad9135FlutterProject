import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpHelper {
  static String movieNightBaseUrl = dotenv.env['MOVIE_NIGHT_BASE_URL']!;
  static String tmdbBaseUrl = dotenv.env['TMDB_BASE_URL']!;
  static String tmdbApiKey = dotenv.env['TMDB_API_KEY']!;

  static Future<Map<String, dynamic>> startSession(String? deviceId) async {
    var response = await http.get(Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    var response = await http.get(Uri.parse('$tmdbBaseUrl/movie/$movieId?api_key=$tmdbApiKey'));
    return jsonDecode(response.body);
  }
}