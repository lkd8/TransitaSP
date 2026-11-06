import 'dart:math';
import '../models/linha_status.dart';

class StatusLinhasService {
  final Random _random = Random();

  static const _linhasBase = [
    (numero: 1, nome: 'Linha 1-Azul', tipo: TipoLinha.metro),
    (numero: 2, nome: 'Linha 2-Verde', tipo: TipoLinha.metro),
    (numero: 3, nome: 'Linha 3-Vermelha', tipo: TipoLinha.metro),
    (numero: 4, nome: 'Linha 4-Amarela', tipo: TipoLinha.metro),
    (numero: 5, nome: 'Linha 5-Lilas', tipo: TipoLinha.metro),
    (numero: 7, nome: 'Linha 7-Rubi', tipo: TipoLinha.trem),
    (numero: 9, nome: 'Linha 9-Esmeralda', tipo: TipoLinha.trem),
    (numero: 11, nome: 'Linha 11-Coral', tipo: TipoLinha.trem),
    (numero: 13, nome: 'Linha 13-Jade', tipo: TipoLinha.trem),
    (numero: 15, nome: 'Linha 15-Prata', tipo: TipoLinha.metro),
  ];

  List<LinhaStatus> gerarStatusSimulado() {
    return _linhasBase.map((linha) {
      final status =
          _random.nextInt(100) < 20 ? StatusLinha.reduzida : StatusLinha.normal;

      return LinhaStatus(
        numero: linha.numero,
        nome: linha.nome,
        tipo: linha.tipo,
        status: status,
      );
    }).toList();
  }
}
