import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginSimples extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  
  const LoginSimples({required this.onLoginSuccess, super.key});

  @override
  _LoginSimplesState createState() => _LoginSimplesState();
}

class _LoginSimplesState extends State<LoginSimples> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authController = AuthController();
  bool _loading = false;
  bool _isRegisterMode = false;

  void _fazerLogin() async {
    setState(() => _loading = true);
    
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha')),
      );
      setState(() => _loading = false);
      return;
    }
    
    bool sucesso = await _authController.login(email, senha);
    
    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido!'), backgroundColor: Colors.green),
      );
      widget.onLoginSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Falha no login - Credenciais inválidas'), backgroundColor: Colors.red),
      );
    }
    
    setState(() => _loading = false);
  }

  void _fazerRegistro() async {
    setState(() => _loading = true);
    
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha email e senha')),
      );
      setState(() => _loading = false);
      return;
    }

    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha deve ter no mínimo 6 caracteres')),
      );
      setState(() => _loading = false);
      return;
    }
    
    bool sucesso = await _authController.register(email, email, senha);
    
    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário criado com sucesso!'), backgroundColor: Colors.green),
      );
      widget.onLoginSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Erro ao registrar - Email pode já estar em uso'), backgroundColor: Colors.red),
      );
    }
    
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegisterMode ? 'Registrar' : 'Login'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRegisterMode ? Icons.person_add : Icons.login,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'seu@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                hintText: 'sua senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                        ),
                        onPressed: _isRegisterMode ? _fazerRegistro : _fazerLogin,
                        child: Text(
                          _isRegisterMode ? 'Registrar' : 'Entrar',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() => _isRegisterMode = !_isRegisterMode);
                          _emailController.clear();
                          _senhaController.clear();
                        },
                        child: Text(
                          _isRegisterMode
                              ? 'Já tem conta? Faça login'
                              : 'Não tem conta? Registre-se',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            Text(
              _isRegisterMode
                  ? 'Crie uma nova conta'
                  : 'Use suas credenciais',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
