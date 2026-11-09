import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transita_sp/models/rotina.dart';
import 'package:transita_sp/services/rotina_service.dart';

void main() {
  final service = RotinaService();

  Rotina rotina({
    required String id,
    required String horario,
    required List<String> dias,
    bool ativa = true,
  }) {
    return Rotina(
      id: id,
      nome: id,
      origem: '',
      destino: '',
      horarioSaida: horario,
      diasSemana: dias,
      modais: const [],
      tempoMetroMin: 0,
      tempoCarroMin: 0,
      ativa: ativa,
    );
  }

  test('prioriza rotinas ativas do dia e ordena pelo horário', () {
    final maisTarde = rotina(
      id: 'mais-tarde',
      horario: '09:00',
      dias: const ['Seg'],
    );
    final desativada = rotina(
      id: 'desativada',
      horario: '06:00',
      dias: const ['Seg'],
      ativa: false,
    );
    final outroDia = rotina(
      id: 'outro-dia',
      horario: '05:00',
      dias: const ['Ter'],
    );
    final maisCedo = rotina(
      id: 'mais-cedo',
      horario: '07:30',
      dias: const ['Seg'],
    );

    expect(
      service.proximaSaida(
        [maisTarde, desativada, outroDia, maisCedo],
        hoje: DateTime(2026, 11, 9),
      ),
      same(maisCedo),
    );
  });

  test('usa todas as rotinas ativas se nenhuma corresponde ao dia', () {
    final maisTarde = rotina(
      id: 'mais-tarde',
      horario: '09:00',
      dias: const ['Ter'],
    );
    final maisCedo = rotina(
      id: 'mais-cedo',
      horario: '07:30',
      dias: const ['Qua'],
    );

    expect(
      service.proximaSaida(
        [maisTarde, maisCedo],
        hoje: DateTime(2026, 11, 9),
      ),
      same(maisCedo),
    );
  });

  test('retorna null quando não há rotinas ativas', () {
    final inativa = rotina(
      id: 'inativa',
      horario: '07:30',
      dias: const ['Seg'],
      ativa: false,
    );

    expect(service.proximaSaida([inativa]), isNull);
  });

  test('retorna a cor da linha ou a cor padrão', () {
    const corPadrao = Color(0xFF123456);

    expect(
      service.corLinhaPorNome('Linha 1-Azul', corPadrao),
      const Color(0xFF0B3CFF),
    );
    expect(
      service.corLinhaPorNome('Linha desconhecida', corPadrao),
      corPadrao,
    );
  });
}
