import 'package:flutter/material.dart';
import '../screens/cadastros_screen.dart';
import '../screens/emprestimos_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1565C0)),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: const Text('Cadastros'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CadastrosScreen()),
            ),
          ),
          ListTile(
            title: const Text('Empréstimos'),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => EmprestimosScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
