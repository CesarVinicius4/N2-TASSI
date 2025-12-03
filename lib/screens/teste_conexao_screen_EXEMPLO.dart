// ============================================================================
// EXEMPLO DE TESTE - Conectando ao Backend Java
// ============================================================================
//
// Cole este código em um arquivo main_test.dart ou em um botão de teste
// para verificar se a conexão com o backend está funcionando
//
// ============================================================================

import 'package:flutter/material.dart';
import '../controllers/livro_controller.dart';

class TesteConexaoScreen extends StatefulWidget {
  const TesteConexaoScreen({super.key});

  @override
  _TesteConexaoScreenState createState() => _TesteConexaoScreenState();
}

class _TesteConexaoScreenState extends State<TesteConexaoScreen> {
  final LivroController _controller = LivroController();
  String _statusTeste = "Aguardando...";
  bool _testando = false;

  void _executarTeste() async {
    setState(() {
      _testando = true;
      _statusTeste = "🔄 Testando conexão...";
    });

    // Teste 1: Buscar todos os livros
    print("\n [TESTE 1] Buscando todos os livros...");
    bool sucesso1 = await _controller.buscarTodosLivros();

    if (sucesso1) {
      print(" [TESTE 1] Sucesso!");
      print("   Total de livros: ${_controller.livros.length}");
      for (var livro in _controller.livros) {
        print("   - $livro");
      }
    } else {
      print(" [TESTE 1] Falhou!");
      print("   Erro: ${_controller.error}");
    }

    // Teste 2: Adicionar novo livro
    print("\n [TESTE 2] Adicionando novo livro...");
    bool sucesso2 = await _controller.adicionarLivro(
      "Livro de Teste",
      5,
    );

    if (sucesso2) {
      print(" [TESTE 2] Sucesso!");
      print("   Novo livro adicionado: ${_controller.livros.last}");
    } else {
      print(" [TESTE 2] Falhou!");
      print("   Erro: ${_controller.error}");
    }

    // Teste 3: Atualizar livro
    if (_controller.livros.isNotEmpty) {
      print("\n [TESTE 3] Alterando livro...");
      final livroTeste = _controller.livros.last;
      bool sucesso3 = await _controller.alterarLivro(
        livroTeste.codigo,
        "Livro Atualizado",
        10,
      );

      if (sucesso3) {
        print(" [TESTE 3] Sucesso!");
        print("   Livro atualizado: ${_controller.livros.last}");
      } else {
        print(" [TESTE 3] Falhou!");
        print("   Erro: ${_controller.error}");
      }
    }

    // Teste 4: Deletar livro
    if (_controller.livros.isNotEmpty) {
      print("\n [TESTE 4] Deletando livro...");
      final codigoDeletar = _controller.livros.last.codigo;
      bool sucesso4 = await _controller.excluirLivro(codigoDeletar);

      if (sucesso4) {
        print(" [TESTE 4] Sucesso!");
        print("   Livro deletado. Total restante: ${_controller.livros.length}");
      } else {
        print(" [TESTE 4] Falhou!");
        print("   Erro: ${_controller.error}");
      }
    }

    setState(() {
      _testando = false;
      if (sucesso1) {
        _statusTeste =
            " CONEXÃO OK!\nLivros encontrados: ${_controller.livros.length}";
      } else {
        _statusTeste =
            " ERRO DE CONEXÃO\n${_controller.error}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Conexão'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_sync,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Teste de Conexão com Backend',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.shade50,
                ),
                child: Text(
                  _statusTeste,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              if (_testando)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Teste'),
                  onPressed: _executarTeste,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'Verifique os logs do console para mais detalhes',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMO USAR:
// ============================================================================
//
// 1. Importe esta tela em main.dart:
//    import 'screens/teste_conexao_screen.dart';
//
// 2. Adicione uma rota no seu navegador:
//    '/teste': (context) => TesteConexaoScreen(),
//
// 3. Ou simplesmente navegue para ela:
//    Navigator.push(context, MaterialPageRoute(
//      builder: (_) => TesteConexaoScreen(),
//    ));
//
// ============================================================================
// RESULTADO ESPERADO NO CONSOLE:
// ============================================================================
//
//  [TESTE 1] Buscando todos os livros...
//  GET request to: http://10.0.2.2:8080/api/livros
//  [TESTE 1] Sucesso!
//    Total de livros: 2
//    - Livro(codigo: 1, nome: Harry Potter, quantidade: 5)
//    - Livro(codigo: 2, nome: Clean Code, quantidade: 3)
//
//  [TESTE 2] Adicionando novo livro...
//  POST request to: http://10.0.2.2:8080/api/livros
//  Body: {"nome":"Livro de Teste","quantidade":5}
//  [TESTE 2] Sucesso!
//    Novo livro adicionado: Livro(codigo: 3, nome: Livro de Teste, quantidade: 5)
//
// ... (mais testes)
//
// ============================================================================
