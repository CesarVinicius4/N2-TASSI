import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import '../controllers/livro_controller.dart';

class CadastrosScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const CadastrosScreen({super.key, this.onLogout});

  @override
  _CadastrosScreenState createState() => _CadastrosScreenState();
}

class _CadastrosScreenState extends State<CadastrosScreen> {
  final LivroController _controller = LivroController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  // Buscar livros do backend ao inicializar
  void _carregarLivros() async {
    bool sucesso = await _controller.buscarTodosLivros();
    setState(() {
      _isInitialized = true;
    });
    
    if (!sucesso && mounted) {
      _mostrarErro(_controller.error ?? "Erro ao carregar livros");
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              final quantidade = int.tryParse(qtdCtrl.text) ?? 0;

              if (nome.isEmpty) {
                _mostrarErro("Nome do livro é obrigatório");
                return;
              }

              if (quantidade <= 0) {
                _mostrarErro("Quantidade deve ser maior que 0");
                return;
              }

              Navigator.pop(context);

              bool sucesso =
                  await _controller.adicionarLivro(nome, quantidade);

              if (sucesso) {
                _mostrarSucesso("Livro adicionado com sucesso!");
                setState(() {});
              } else {
                _mostrarErro(_controller.error ?? "Erro ao adicionar livro");
              }
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
            onPressed: () async {
              final nome = nomeCtrl.text.trim();
              final quantidade = int.tryParse(qtdCtrl.text) ?? 0;

              if (nome.isEmpty) {
                _mostrarErro("Nome do livro é obrigatório");
                return;
              }

              if (quantidade <= 0) {
                _mostrarErro("Quantidade deve ser maior que 0");
                return;
              }

              Navigator.pop(context);

              bool sucesso =
                  await _controller.alterarLivro(codigo, nome, quantidade);

              if (sucesso) {
                _mostrarSucesso("Livro atualizado!");
                setState(() {});
              } else {
                _mostrarErro(_controller.error ?? "Erro ao alterar livro");
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  // ---------- Função excluir ----------
  void _excluirLivro(int codigo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("Tem certeza que deseja excluir este livro?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              bool sucesso = await _controller.excluirLivro(codigo);

              if (sucesso) {
                _mostrarSucesso("Livro removido!");
                setState(() {});
              } else {
                _mostrarErro(_controller.error ?? "Erro ao excluir livro");
              }
            },
            child: const Text("Excluir"),
          ),
        ],
      ),
    );
  }
  //UI DA TELA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('CADASTROS'),
        backgroundColor: const Color(0xFF1565C0),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: widget.onLogout,
          ),
        ],
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
            // Indicador de carregamento
            if (_controller.isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),

            // Mensagem de erro se houver
            if (_controller.error != null && !_controller.isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _controller.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Botão para recarregar
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Recarregar"),
              onPressed: _carregarLivros,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            // Lista de livros
            Expanded(
              child: !_isInitialized
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _controller.livros.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.library_books,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                "Nenhum livro cadastrado",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text("Adicionar Livro"),
                                onPressed: _novoLivro,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _controller.livros.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Colors.grey),
                          itemBuilder: (_, index) {
                            final livro = _controller.livros[index];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  livro.codigo.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(livro.nome),
                              subtitle:
                                  Text("Quantidade: ${livro.quantidade}"),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text("Editar"),
                                      ],
                                    ),
                                    onTap: () =>
                                        _alterarLivro(livro.codigo),
                                  ),
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text("Excluir"),
                                      ],
                                    ),
                                    onTap: () =>
                                        _excluirLivro(livro.codigo),
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
