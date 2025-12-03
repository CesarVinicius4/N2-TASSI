import 'package:flutter/material.dart';
import 'screens/login_simples.dart';
import 'screens/cadastros_screen.dart';
import 'controllers/auth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Biblioteca',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final _authController = AuthController();
  bool _logado = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  void _verificarLogin() async {
    bool temToken = await _authController.hasToken();
    setState(() {
      _logado = temToken;
      _carregando = false;
    });
  }

  void _fazerLogout() {
    _authController.logout();
    setState(() {
      _logado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_logado) {
      return LoginSimples(
        onLoginSuccess: () {
          setState(() => _logado = true);
        },
      );
    }

    return CadastrosScreen(onLogout: _fazerLogout);
  }
}
