import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import '../controllers/emprestimo_controller.dart';

class EmprestimosScreen extends StatefulWidget {
  const EmprestimosScreen({super.key});

  @override
  _EmprestimosScreenState createState() => _EmprestimosScreenState();
}

class _EmprestimosScreenState extends State<EmprestimosScreen> {
  final EmprestimoController _controller = EmprestimoController();

  void _novoEmprestimo() {
    TextEditingController clienteCtrl = TextEditingController();
    TextEditingController livroCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Empréstimo'),
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
            onPressed: () {
              setState(() {
                _controller.adicionarEmprestimo(
                  clienteCtrl.text,
                  livroCtrl.text,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
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
            onPressed: () {
              setState(() {
                _controller.alterarEmprestimo(
                  id,
                  clienteCtrl.text,
                  livroCtrl.text,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar alterações'),
          ),
        ],
      ),
    );
  }

  void _excluirEmprestimo(int id) {
    setState(() {
      _controller.removerEmprestimo(id);
    });
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
