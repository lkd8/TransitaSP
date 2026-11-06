class Endereco {
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;

  Endereco({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.cidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  String get resumo {
    final partes =
        [logradouro, bairro, '$cidade/$uf'].where((p) => p.trim().isNotEmpty);
    return partes.join(', ');
  }
}
