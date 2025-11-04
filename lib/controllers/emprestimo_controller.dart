import '../models/emprestimo.dart';

class EmprestimoController {
  final List<Emprestimo> _emprestimos = [
    Emprestimo(id: 1, cliente: 'João Silva', livro: 'O Senhor dos Anéis'),
  ];

  List<Emprestimo> get emprestimos => _emprestimos;

  void adicionarEmprestimo(String cliente, String livro) {
    final novoId = _emprestimos.isEmpty ? 1 : _emprestimos.last.id + 1;
    _emprestimos.add(Emprestimo(id: novoId, cliente: cliente, livro: livro));
  }

  void removerEmprestimo(int id) {
    _emprestimos.removeWhere((emp) => emp.id == id);
  }

  void alterarEmprestimo(int id, String cliente, String livro) {
    final index = _emprestimos.indexWhere((emp) => emp.id == id);
    if (index != -1) {
      _emprestimos[index] =
          Emprestimo(id: id, cliente: cliente, livro: livro);
    }
  }
}
