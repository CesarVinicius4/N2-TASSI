import 'package:flutter/material.dart';
import 'livro_controller.dart';

class CadastroLivroController {
  final LivroController livroController;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  CadastroLivroController(this.livroController);

  // Função para salvar o livro novo
  bool salvarLivro() {
    final nome = nomeController.text.trim();
    final quantidadeTexto = quantidadeController.text.trim();

    if (nome.isEmpty || quantidadeTexto.isEmpty) {
      return false; // erro de validação
    }

    final quantidade = int.tryParse(quantidadeTexto);
    if (quantidade == null || quantidade < 1) {
      return false; // quantidade inválida
    }

    livroController.adicionarLivro(nome, quantidade);

    limparCampos();

    return true;
  }

  // Limpa os inputs após cadastro
  void limparCampos() {
    nomeController.clear();
    quantidadeController.clear();
  }
}
