import 'dart:math';
import '../models/rotina.dart';
import '../models/linha_status.dart';

enum ModalRecomendado { metro, carro }

class Recomendacao {
  final ModalRecomendado modal;
  final double tempoMetroMin;
  final double tempoCarroMin;
  final String justificativa;

  Recomendacao({
    required this.modal,
    required this.tempoMetroMin,
    required this.tempoCarroMin,
    required this.justificativa,
  });
}

class RecomendacaoService {
  final Random _random = Random();

  Recomendacao gerar(Rotina rotina, List<LinhaStatus> statusLinhas) {
    final temLinhaReduzida =
        statusLinhas.any((l) => l.status == StatusLinha.reduzida);

    final tempoMetro = rotina.tempoMetroMin + (temLinhaReduzida ? 12 : 0);

    final fatorTransito = 1 + (_random.nextInt(91) / 100);
    final tempoCarro = rotina.tempoCarroMin * fatorTransito;

    final ModalRecomendado modal;
    final String justificativa;

    if (tempoMetro <= tempoCarro) {
      modal = ModalRecomendado.metro;
      final diferenca = (tempoCarro - tempoMetro).round();
      justificativa = diferenca > 0
          ? 'Metro/Trem deve chegar cerca de $diferenca min antes que carro.'
          : 'Metro/Trem e carro ficam praticamente empatados hoje.';
    } else {
      modal = ModalRecomendado.carro;
      final diferenca = (tempoMetro - tempoCarro).round();
      justificativa =
          'Carro/Moto deve chegar cerca de $diferenca min antes que metro/trem.';
    }

    return Recomendacao(
      modal: modal,
      tempoMetroMin: tempoMetro,
      tempoCarroMin: tempoCarro,
      justificativa: justificativa,
    );
  }
}
