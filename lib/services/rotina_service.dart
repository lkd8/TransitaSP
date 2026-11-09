import 'package:flutter/material.dart';
import '../models/rotina.dart';

class RotinaService {
  Rotina? proximaSaida(List<Rotina> rotinas, {DateTime? hoje}) {
    final rotinasAtivas = rotinas.where((rotina) => rotina.ativa).toList();
    if (rotinasAtivas.isEmpty) return null;

    final data = hoje ?? DateTime.now();
    final diaHoje =
        ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'][data.weekday % 7];
    final rotinasDoDia = rotinasAtivas
        .where((rotina) => rotina.diasSemana.contains(diaHoje))
        .toList();
    final candidatas = rotinasDoDia.isNotEmpty ? rotinasDoDia : rotinasAtivas;

    candidatas.sort((a, b) {
      final horaA = int.tryParse(a.horarioSaida.split(':').first) ?? 0;
      final minutoA = int.tryParse(a.horarioSaida.split(':').last) ?? 0;
      final horaB = int.tryParse(b.horarioSaida.split(':').first) ?? 0;
      final minutoB = int.tryParse(b.horarioSaida.split(':').last) ?? 0;
      final valorA = horaA * 60 + minutoA;
      final valorB = horaB * 60 + minutoB;
      return valorA.compareTo(valorB);
    });

    return candidatas.first;
  }

  Color corLinhaPorNome(String linha, Color corPadrao) {
    final numero = int.tryParse(linha.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    switch (numero) {
      case 1:
        return const Color(0xFF0B3CFF);
      case 2:
        return const Color(0xFF00A651);
      case 3:
        return const Color(0xFFE41E2A);
      case 4:
        return const Color(0xFFF6C544);
      case 5:
        return const Color(0xFF8A4CBE);
      case 7:
        return const Color(0xFFB35A9B);
      case 9:
        return const Color(0xFF009C71);
      case 11:
        return const Color(0xFFF38A42);
      case 13:
        return const Color(0xFF4FBF9F);
      case 15:
        return const Color(0xFF9CA3AF);
      default:
        return corPadrao;
    }
  }
}
