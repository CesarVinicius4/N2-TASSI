import '../models/livro.dart';

class LivroController {
  final List<Livro> _livros = [
    Livro(codigo: 1, nome: "Livro 1", quantidade: 5),
    Livro(codigo: 2, nome: "Livro 2", quantidade: 3),
  ];

  List<Livro> get livros => _livros;

  void adicionarLivro(String nome, int quantidade) {
    final novoCodigo = _livros.isEmpty ? 1 : _livros.last.codigo + 1;
    _livros.add(Livro(
      codigo: novoCodigo,
      nome: nome,
      quantidade: quantidade,
    ));
  }

  void excluirLivro(int codigo) {
    _livros.removeWhere((livro) => livro.codigo == codigo);
  }

  void alterarLivro(int codigo, String nome, int quantidade) {
    final index = _livros.indexWhere((livro) => livro.codigo == codigo);
    if (index != -1) {
      _livros[index] = Livro(
        codigo: codigo,
        nome: nome,
        quantidade: quantidade,
      );
    }
  }
}
