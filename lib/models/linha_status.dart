enum StatusLinha {
  normal('Operação normal'),
  reduzida('Velocidade reduzida');

  final String label;
  const StatusLinha(this.label);
}

enum TipoLinha {
  metro('Metrô'),
  trem('Trem metropolitano');

  final String label;
  const TipoLinha(this.label);
}

class LinhaStatus {
  final int numero;
  final String nome;
  final TipoLinha tipo;
  final StatusLinha status;

  const LinhaStatus({
    required this.numero,
    required this.nome,
    required this.tipo,
    required this.status,
  });
}
