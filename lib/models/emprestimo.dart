class Emprestimo {
  int id;
  String cliente;
  String livro;

  Emprestimo({
    required this.id,
    required this.cliente,
    required this.livro,
  });

  // Converter JSON para Emprestimo
  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    return Emprestimo(
      id: json['id'] as int,
      cliente: json['cliente'] as String,
      livro: json['livro'] as String,
    );
  }

  // Converter Emprestimo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente': cliente,
      'livro': livro,
    };
  }
}
