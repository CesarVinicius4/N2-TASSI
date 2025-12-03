import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/config.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  
  // Timeout padrão de 30 segundos
  static const Duration timeoutDuration = Duration(seconds: 30);

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<http.Response> get(String endpoint) async {
    final token = await getToken();
    final url = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      print('GET request to: $url');
      
      final headers = {
        "Content-Type": "application/json",
      };
      
      // Adicionar token apenas se existir
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
      
      return await http
          .get(url, headers: headers)
          .timeout(timeoutDuration);
    } catch (e) {
      print(' GET request failed: $e');
      rethrow;
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    final url = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      print(' POST request to: $url');
      print('📦 Body: ${jsonEncode(body)}');
      
      final headers = {
        "Content-Type": "application/json",
      };
      
      // Adicionar token apenas se existir
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
      
      return await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration);
    } catch (e) {
      print(' POST request failed: $e');
      rethrow;
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    final url = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      print(' PUT request to: $url');
      
      final headers = {
        "Content-Type": "application/json",
      };
      
      // Adicionar token apenas se existir
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
      
      return await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(timeoutDuration);
    } catch (e) {
      print(' PUT request failed: $e');
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final token = await getToken();
    final url = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      print(' DELETE request to: $url');
      
      final headers = {
        "Content-Type": "application/json",
      };
      
      // Adicionar token apenas se existir
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
      
      return await http
          .delete(url, headers: headers)
          .timeout(timeoutDuration);
    } catch (e) {
      print(' DELETE request failed: $e');
      rethrow;
    }
  }
}
