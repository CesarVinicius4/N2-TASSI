import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/config.dart';

class AuthController {
  final storage = const FlutterSecureStorage();

  // Registrar novo usuário
  Future<bool> register(String email, String nome, String senha) async {
    final url = Uri.parse("${AppConfig.baseUrl}/auth/register");
    
    try {
      print('Registrando novo usuário em: $url');
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "nome": nome,
          "senha": senha,
        }),
      ).timeout(const Duration(seconds: 10));
      
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        if (token != null) {
          // Salvar token de forma segura
          await storage.write(key: 'token', value: token);
          print('Registro bem-sucedido! Token salvo.');
          return true;
        }
      }
      
      print('Falha no registro: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Erro ao registrar: $e');
      return false;
    }
  }

  // Fazer login e obter JWT token
  Future<bool> login(String email, String senha) async {
    final url = Uri.parse("${AppConfig.baseUrl}/auth/login");
    
    try {
      print('Tentando login em: $url');
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "senha": senha,
        }),
      ).timeout(const Duration(seconds: 10));
      
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        if (token != null) {
          // Salvar token de forma segura
          await storage.write(key: 'token', value: token);
          print('Login bem-sucedido! Token salvo.');
          return true;
        }
      }
      
      print('Falha no login: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return false;
    }
  }

  // Fazer logout
  Future<void> logout() async {
    await storage.delete(key: 'token');
    print('Logout realizado.');
  }

  // Verificar se já tem token
  Future<bool> hasToken() async {
    final token = await storage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }
}
