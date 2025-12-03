import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import '../controllers/emprestimo_controller.dart';
import '../controllers/livro_controller.dart';
import '../models/livro.dart';

class EmprestimosScreen extends StatefulWidget {
  const EmprestimosScreen({super.key});

  @override
  _EmprestimosScreenState createState() => _EmprestimosScreenState();
}

class _EmprestimosScreenState extends State<EmprestimosScreen> {
  final EmprestimoController _controller = EmprestimoController();

  @override
  void initState() {
    super.initState();
    _carregarEmprestimos();
  }

  Future<void> _carregarEmprestimos() async {
    await _controller.carregarEmprestimos();
    setState(() {});
  }

  void _novoEmprestimo() async {
    TextEditingController clienteCtrl = TextEditingController();
    
    // Buscar livros do backend
    final livroController = LivroController();
    await livroController.buscarTodosLivros();
    
    Livro? livroSelecionado;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Novo Empréstimo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: clienteCtrl,
                decoration: const InputDecoration(labelText: 'Nome do cliente'),
              ),
              const SizedBox(height: 16),
              if (livroController.isLoading)
                const CircularProgressIndicator()
              else if (livroController.livros.isEmpty)
                const Text('Nenhum livro disponível')
              else
                DropdownButton<Livro>(
                  hint: const Text('Selecione um livro'),
                  value: livroSelecionado,
                  onChanged: (Livro? novoValor) {
                    setStateDialog(() {
                      livroSelecionado = novoValor;
                    });
                  },
                  items: livroController.livros.map((livro) {
                    return DropdownMenuItem<Livro>(
                      value: livro,
                      child: Text(livro.nome),
                    );
                  }).toList(),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: (livroSelecionado == null || clienteCtrl.text.isEmpty)
                  ? null
                  : () async {
                      final sucesso = await _controller.adicionarEmprestimo(
                        clienteCtrl.text,
                        livroSelecionado!.nome,
                      );
                      Navigator.pop(context);
                      if (sucesso) {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Empréstimo adicionado!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro: ${_controller.erro}')),
                        );
                      }
                    },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  void _alterarEmprestimo(int id) {
    final emp = _controller.emprestimos.firstWhere((e) => e.id == id);
    TextEditingController clienteCtrl = TextEditingController(text: emp.cliente);
    TextEditingController livroCtrl = TextEditingController(text: emp.livro);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Empréstimo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: clienteCtrl,
              decoration: const InputDecoration(labelText: 'Nome do cliente'),
            ),
            TextField(
              controller: livroCtrl,
              decoration: const InputDecoration(labelText: 'Nome do livro'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final sucesso = await _controller.alterarEmprestimo(
                id,
                clienteCtrl.text,
                livroCtrl.text,
              );
              Navigator.pop(context);
              if (sucesso) {
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Empréstimo atualizado!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro: ${_controller.erro}')),
                );
              }
            },
            child: const Text('Salvar alterações'),
          ),
        ],
      ),
    );
  }

  void _excluirEmprestimo(int id) async {
    final sucesso = await _controller.removerEmprestimo(id);
    if (sucesso) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empréstimo removido!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${_controller.erro}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('EMPRÉSTIMOS'),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _controller.emprestimos.isNotEmpty
                      ? () => _excluirEmprestimo(_controller.emprestimos.last.id)
                      : null,
                  child: const Text('Excluir empréstimo'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _controller.emprestimos.isNotEmpty
                      ? () => _alterarEmprestimo(_controller.emprestimos.last.id)
                      : null,
                  child: const Text('Alterar cadastro'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _novoEmprestimo,
                  child: const Text('Novo empréstimo'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_controller.carregando)
              const CircularProgressIndicator()
            else if (_controller.emprestimos.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Nenhum empréstimo encontrado'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _controller.emprestimos.length,
                  itemBuilder: (context, index) {
                    final emp = _controller.emprestimos[index];
                    return ListTile(
                      title: Text("${emp.id} - ${emp.livro}"),
                      subtitle: Text("Cliente: ${emp.cliente}"),
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
