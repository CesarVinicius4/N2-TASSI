import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/config.dart';

class ApiService {
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<http.Response> get(String endpoint) async {
    final token = await getToken();

    return await http.get(
      Uri.parse("${AppConfig.baseUrl}$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();

    return await http.post(
      Uri.parse("${AppConfig.baseUrl}$endpoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
  }
}
