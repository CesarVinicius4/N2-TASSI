import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/config.dart';
import '../models/emprestimo.dart';

class EmprestimoController {
  final List<Emprestimo> _emprestimos = [];
  final storage = const FlutterSecureStorage();
  bool _carregando = false;
  String? _erro;

  List<Emprestimo> get emprestimos => _emprestimos;
  bool get carregando => _carregando;
  String? get erro => _erro;

  // Buscar todos os empréstimos do backend
  Future<void> carregarEmprestimos() async {
    _carregando = true;
    _erro = null;

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        _erro = 'Token não encontrado';
        _carregando = false;
        return;
      }

      final url = Uri.parse("${AppConfig.baseUrl}/emprestimos");
      print('GET request to: $url');

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _emprestimos.clear();
        _emprestimos.addAll(data.map((e) => Emprestimo.fromJson(e)).toList());
        print('${_emprestimos.length} empréstimos carregados');
      } else {
        _erro = 'Erro ao carregar: ${response.statusCode}';
        print('❌ Erro: $_erro');
      }
    } catch (e) {
      _erro = 'Erro ao buscar empréstimos: $e';
      print('❌ Erro: $_erro');
    } finally {
      _carregando = false;
    }
  }

  // Adicionar novo empréstimo
  Future<bool> adicionarEmprestimo(String cliente, String livro) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        _erro = 'Token não encontrado';
        return false;
      }

      final url = Uri.parse("${AppConfig.baseUrl}/emprestimos");
      final body = jsonEncode({
        "cliente": cliente,
        "livro": livro,
      });

      print('🟢 POST request to: $url');
      print('Body: $body');

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final novoEmprestimo = Emprestimo.fromJson(jsonDecode(response.body));
        _emprestimos.add(novoEmprestimo);
        print('Empréstimo adicionado!');
        return true;
      } else {
        _erro = 'Erro ao adicionar: ${response.statusCode}';
        print('❌ Erro: $_erro');
        return false;
      }
    } catch (e) {
      _erro = 'Erro ao adicionar empréstimo: $e';
      print('❌ Erro: $_erro');
      return false;
    }
  }

  // Remover empréstimo
  Future<bool> removerEmprestimo(int id) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        _erro = 'Token não encontrado';
        return false;
      }

      final url = Uri.parse("${AppConfig.baseUrl}/emprestimos/$id");
      print('🔴 DELETE request to: $url');

      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 204 || response.statusCode == 200) {
        _emprestimos.removeWhere((emp) => emp.id == id);
        print('Empréstimo removido!');
        return true;
      } else {
        _erro = 'Erro ao remover: ${response.statusCode}';
        print('❌ Erro: $_erro');
        return false;
      }
    } catch (e) {
      _erro = 'Erro ao remover empréstimo: $e';
      print('❌ Erro: $_erro');
      return false;
    }
  }

  // Alterar empréstimo
  Future<bool> alterarEmprestimo(
      int id, String cliente, String livro) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        _erro = 'Token não encontrado';
        return false;
      }

      final url = Uri.parse("${AppConfig.baseUrl}/emprestimos/$id");
      final body = jsonEncode({
        "cliente": cliente,
        "livro": livro,
      });

      print('🟡 PUT request to: $url');
      print('Body: $body');

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      ).timeout(const Duration(seconds: 10));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final emprestimoAtualizado =
            Emprestimo.fromJson(jsonDecode(response.body));
        final index = _emprestimos.indexWhere((emp) => emp.id == id);
        if (index != -1) {
          _emprestimos[index] = emprestimoAtualizado;
        }
        print('Empréstimo atualizado!');
        return true;
      } else {
        _erro = 'Erro ao atualizar: ${response.statusCode}';
        print('❌ Erro: $_erro');
        return false;
      }
    } catch (e) {
      _erro = 'Erro ao atualizar empréstimo: $e';
      print('❌ Erro: $_erro');
      return false;
    }
  }
}
