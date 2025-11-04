import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import '../controllers/livro_controller.dart';

class CadastrosScreen extends StatefulWidget {
  const CadastrosScreen({super.key});

  @override
  _CadastrosScreenState createState() => _CadastrosScreenState();
}

class _CadastrosScreenState extends State<CadastrosScreen> {
  final LivroController _controller = LivroController();

  void _novoLivro() {
    TextEditingController nomeCtrl = TextEditingController();
    TextEditingController qtdCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Novo Livro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome do livro"),
            ),
            TextField(
              controller: qtdCtrl,
              decoration: const InputDecoration(labelText: "Quantidade"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _controller.adicionarLivro(
                  nomeCtrl.text,
                  int.tryParse(qtdCtrl.text) ?? 0,
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _excluirLivro(int codigo) {
    setState(() {
      _controller.excluirLivro(codigo);
    });
  }

  void _alterarLivro(int codigo) {
    final livro = _controller.livros.firstWhere((l) => l.codigo == codigo);
    TextEditingController nomeCtrl = TextEditingController(text: livro.nome);
    TextEditingController qtdCtrl =
        TextEditingController(text: livro.quantidade.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alterar Livro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome do livro"),
            ),
            TextField(
              controller: qtdCtrl,
              decoration: const InputDecoration(labelText: "Quantidade"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _controller.alterarLivro(
                  codigo,
                  nomeCtrl.text,
                  int.tryParse(qtdCtrl.text) ?? 0,
                );
              });
              Navigator.pop(context);
            },
            child: const Text("Salvar alterações"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('CADASTROS'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF44336)),
                  onPressed: _controller.livros.isNotEmpty
                      ? () =>
                          _excluirLivro(_controller.livros.last.codigo)
                      : null,
                  child: const Text('Excluir livro'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3)),
                  onPressed: _controller.livros.isNotEmpty
                      ? () =>
                          _alterarLivro(_controller.livros.last.codigo)
                      : null,
                  child: const Text('Alterar cadastro'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
                  onPressed: _novoLivro,
                  child: const Text('Novo livro'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.livros.length,
                itemBuilder: (context, index) {
                  final livro = _controller.livros[index];
                  return ListTile(
                    title: Text("${livro.codigo} - ${livro.nome}"),
                    subtitle: Text("Qtd: ${livro.quantidade}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
