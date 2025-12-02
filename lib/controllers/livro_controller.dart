import '../models/livro.dart';

class LivroController {
  final List<Livro> _livros = [
    Livro(codigo: 1, nome: "Livro 1", quantidade: 5),
    Livro(codigo: 2, nome: "Livro 2", quantidade: 3),
  ];

  // Getter que retorna a lista de livros
  List<Livro> get livros => List.unmodifiable(_livros);

  // Adicionar um novo livro
  void adicionarLivro(String nome, int quantidade) {
    final novoCodigo = _livros.isEmpty ? 1 : _livros.last.codigo + 1;

    _livros.add(
      Livro(
        codigo: novoCodigo,
        nome: nome,
        quantidade: quantidade,
      ),
    );
  }

  // Excluir um livro pelo código
  void excluirLivro(int codigo) {
    _livros.removeWhere((livro) => livro.codigo == codigo);
  }

  // Atualizar informações de um livro existente
  void alterarLivro(int codigo, String novoNome, int novaQuantidade) {
    final index = _livros.indexWhere((livro) => livro.codigo == codigo);

    if (index != -1) {
      _livros[index] = Livro(
        codigo: codigo,
        nome: novoNome,
        quantidade: novaQuantidade,
      );
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
