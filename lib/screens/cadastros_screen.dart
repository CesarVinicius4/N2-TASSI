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

  // ---------- Função para cadastrar um novo livro ----------
  void _novoLivro() {
    final nomeCtrl = TextEditingController();
    final qtdCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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

  // ---------- Função para editar ----------
  void _alterarLivro(int codigo) {
    final livro = _controller.livros.firstWhere((l) => l.codigo == codigo);
    final nomeCtrl = TextEditingController(text: livro.nome);
    final qtdCtrl = TextEditingController(text: livro.quantidade.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // ---------- Função excluir ----------
  void _excluirLivro(int codigo) {
    setState(() {
      _controller.excluirLivro(codigo);
    });
  }

  // ============================================================
  //                         UI DA TELA
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('CADASTROS'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _novoLivro,
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // ------------------ Botões principais ------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _controller.livros.isNotEmpty
                      ? () => _excluirLivro(_controller.livros.last.codigo)
                      : null,
                  child: const Text("Excluir último"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _controller.livros.isNotEmpty
                      ? () => _alterarLivro(_controller.livros.last.codigo)
                      : null,
                  child: const Text("Alterar último"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------ Lista de livros ------------------
            Expanded(
              child: _controller.livros.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum livro cadastrado",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _controller.livros.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.grey),
                      itemBuilder: (_, index) {
                        final livro = _controller.livros[index];

                        return ListTile(
                          title: Text("${livro.codigo} - ${livro.nome}"),
                          subtitle: Text("Quantidade: ${livro.quantidade}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _alterarLivro(livro.codigo),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _excluirLivro(livro.codigo),
                              ),
                            ],
                          ),
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
