import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiClient {
  static String get baseUrl {
    // If running on web or iOS simulator
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } 
    // If running on Android emulator
    else if (Platform.isAndroid) {
      // 10.0.2.2 is the special alias to your host loopback interface (localhost) on Android emulator
      // If you are using a PHYSICAL Android phone, you need to change this to your PC's local IP (e.g. 192.168.1.5:3000)
      return 'http://10.0.2.2:3000/api';
    } 
    // Fallback
    return 'http://localhost:3000/api';
  }

  static Future<Map<String, String>> get _headers async {
    final user = FirebaseAuth.instance.currentUser;
    String? token;
    
    if (user != null) {
      token = await user.getIdToken();
    }

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('GET $endpoint failed: $e');
      rethrow;
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _headers,
        body: json.encode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('POST $endpoint failed: $e');
      rethrow;
    }
  }
}
