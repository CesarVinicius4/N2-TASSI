import 'dart:convert';
import '../models/livro.dart';
import '../services/api_service.dart';

class LivroController {
  final ApiService _apiService = ApiService();
  final List<Livro> _livros = [];
  
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter que retorna a lista de livros
  List<Livro> get livros => List.unmodifiable(_livros);

  // Buscar todos os livros do backend
  Future<bool> buscarTodosLivros() async {
    _isLoading = true;
    _error = null;
    
    try {
      final response = await _apiService.get('/livros');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _livros.clear();
        _livros.addAll(data.map((json) => Livro.fromJson(json)).toList());
        _isLoading = false;
        return true;
      } else {
        _error = 'Erro ao buscar livros: ${response.statusCode}';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      _error = 'Erro de conexão: $e';
      _isLoading = false;
      print('❌ Erro ao buscar livros: $e');
      return false;
    }
  }

  // Adicionar um novo livro no backend
  Future<bool> adicionarLivro(String nome, int quantidade) async {
    _isLoading = true;
    _error = null;
    
    try {
      final response = await _apiService.post('/livros', {
        'nome': nome,
        'quantidade': quantidade,
      });
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        _livros.add(Livro.fromJson(json));
        _isLoading = false;
        return true;
      } else {
        _error = 'Erro ao adicionar livro: ${response.statusCode}';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      _error = 'Erro de conexão: $e';
      _isLoading = false;
      print('❌ Erro ao adicionar livro: $e');
      return false;
    }
  }

  // Excluir um livro pelo código
  Future<bool> excluirLivro(int codigo) async {
    _isLoading = true;
    _error = null;
    
    try {
      final response = await _apiService.delete('/livros/$codigo');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        _livros.removeWhere((livro) => livro.codigo == codigo);
        _isLoading = false;
        return true;
      } else {
        _error = 'Erro ao excluir livro: ${response.statusCode}';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      _error = 'Erro de conexão: $e';
      _isLoading = false;
      print('❌ Erro ao excluir livro: $e');
      return false;
    }
  }

  // Atualizar informações de um livro existente
  Future<bool> alterarLivro(int codigo, String novoNome, int novaQuantidade) async {
    _isLoading = true;
    _error = null;
    
    try {
      final response = await _apiService.put('/livros/$codigo', {
        'nome': novoNome,
        'quantidade': novaQuantidade,
      });
      
      if (response.statusCode == 200) {
        final index = _livros.indexWhere((livro) => livro.codigo == codigo);
        if (index != -1) {
          _livros[index] = Livro(
            codigo: codigo,
            nome: novoNome,
            quantidade: novaQuantidade,
          );
        }
        _isLoading = false;
        return true;
      } else {
        _error = 'Erro ao alterar livro: ${response.statusCode}';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      _error = 'Erro de conexão: $e';
      _isLoading = false;
      print('❌ Erro ao alterar livro: $e');
      return false;
    }
  }

  // Buscar livro pelo código
  Livro? buscarPorCodigo(int codigo) {
    try {
      return _livros.firstWhere((livro) => livro.codigo == codigo);
    } catch (_) {
      return null;
    }
  }
}
