class Rotina {
  final String id;
  String nome;
  String origem;
  String destino;
  String horarioSaida;
  List<String> diasSemana;
  List<String> modais;
  List<String> linhas;
  double tempoMetroMin;
  double tempoCarroMin;
  bool ativa;

  Rotina({
    required this.id,
    required this.nome,
    required this.origem,
    required this.destino,
    required this.horarioSaida,
    required this.diasSemana,
    required this.modais,
    this.linhas = const [],
    required this.tempoMetroMin,
    required this.tempoCarroMin,
    this.ativa = true,
  });

  factory Rotina.fromJson(Map<String, dynamic> json) {
    return Rotina(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      origem: json['origem'] ?? '',
      destino: json['destino'] ?? '',
      horarioSaida: json['horarioSaida'] ?? '',
      diasSemana: List<String>.from(json['diasSemana'] ?? []),
      modais: List<String>.from(json['modais'] ?? []),
      linhas: List<String>.from(json['linhas'] ?? []),
      tempoMetroMin: (json['tempoMetroMin'] ?? 0).toDouble(),
      tempoCarroMin: (json['tempoCarroMin'] ?? 0).toDouble(),
      ativa: json['ativa'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'origem': origem,
      'destino': destino,
      'horarioSaida': horarioSaida,
      'diasSemana': diasSemana,
      'modais': modais,
      'linhas': linhas,
      'tempoMetroMin': tempoMetroMin,
      'tempoCarroMin': tempoCarroMin,
      'ativa': ativa,
    };
  }
}
