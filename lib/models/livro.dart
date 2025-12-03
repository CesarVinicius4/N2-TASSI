class Livro {
  int codigo;
  String nome;
  int quantidade;

  Livro({
    required this.codigo,
    required this.nome,
    required this.quantidade,
  });

  // Converter JSON para objeto Livro
  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      codigo: json['codigo'] ?? json['id'] ?? 0,
      nome: json['nome'] ?? '',
      quantidade: json['quantidade'] ?? 0,
    );
  }

  // Converter objeto Livro para JSON
  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nome': nome,
      'quantidade': quantidade,
    };
  }

  @override
  String toString() => 'Livro(codigo: $codigo, nome: $nome, quantidade: $quantidade)';
}
