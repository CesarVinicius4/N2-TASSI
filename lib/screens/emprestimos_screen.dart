import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/data_table_widget.dart';

class EmprestimosScreen extends StatelessWidget {
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
                  onPressed: () {},
                  child: const Text('Excluir empréstimo'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {},
                  child: const Text('Alterar cadastro'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {},
                  child: const Text('Novo empréstimo'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: DataTableWidget(
                title1: 'EMPRÉSTIMOS ATIVOS',
                title2: 'CLIENTE',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
