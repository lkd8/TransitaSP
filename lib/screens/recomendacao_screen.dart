import 'package:flutter/material.dart';
import '../theme/theme_toggle_scope.dart';
import '../models/rotina.dart';
import '../services/status_linhas_service.dart';
import '../services/recomendacao_service.dart';
import '../services/preferences_service.dart';

class RecomendacaoScreen extends StatefulWidget {
  final Rotina rotina;

  const RecomendacaoScreen({super.key, required this.rotina});

  @override
  State<RecomendacaoScreen> createState() => _RecomendacaoScreenState();
}

class _RecomendacaoScreenState extends State<RecomendacaoScreen> {
  final StatusLinhasService _statusLinhasService = StatusLinhasService();
  final RecomendacaoService _recomendacaoService = RecomendacaoService();
  final PreferencesService _preferencesService = PreferencesService();

  Recomendacao? _recomendacao;
  DateTime? _geradaEm;
  String? _feedback;

  final List<String> _historico = [];

  @override
  void initState() {
    super.initState();
    _gerarRecomendacao();
  }

  void _gerarRecomendacao() {
    final statusLinhas = _statusLinhasService.gerarStatusSimulado();
    final recomendacao =
        _recomendacaoService.gerar(widget.rotina, statusLinhas);

    setState(() {
      _recomendacao = recomendacao;
      _geradaEm = DateTime.now();
      _feedback = null;
    });
  }

  Future<void> _registrarFeedback(bool seguiu) async {
    final recomendacao = _recomendacao;
    if (recomendacao == null) return;

    if (seguiu) {
      final tempoNaoEscolhido = recomendacao.modal == ModalRecomendado.metro
          ? recomendacao.tempoCarroMin
          : recomendacao.tempoMetroMin;
      final tempoEscolhido = recomendacao.modal == ModalRecomendado.metro
          ? recomendacao.tempoMetroMin
          : recomendacao.tempoCarroMin;

      final minutosGanhos = (tempoNaoEscolhido - tempoEscolhido).round();
      if (minutosGanhos > 0) {
        final atual = await _preferencesService.getMinutosEconomizados();
        await _preferencesService
            .saveMinutosEconomizados(atual + minutosGanhos);
      }
    }

    setState(() {
      _feedback = seguiu
          ? 'Voce seguiu a recomendacao.'
          : 'Voce nao seguiu a recomendacao.';
      _historico.insert(
        0,
        '${TimeOfDay.now().format(context)} · '
        '${recomendacao.modal == ModalRecomendado.metro ? 'Metro/Trem' : 'Carro/Moto'} · '
        '${seguiu ? 'Seguiu' : 'Nao seguiu'}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final rotina = widget.rotina;
    final recomendacao = _recomendacao;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeToggle = ThemeToggleScope.of(context)?.toggleTheme ?? () {};

    return Scaffold(
      appBar: AppBar(
        title: Text(rotina.nome),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            tooltip: isDarkMode ? 'Ativar modo claro' : 'Ativar modo escuro',
            onPressed: themeToggle,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${rotina.origem} -> ${rotina.destino}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Saida: ${rotina.horarioSaida}'),
                  Text('Dias: ${rotina.diasSemana.join(', ')}'),
                  Text('Modais: ${rotina.modais.join(', ')}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recomendacao',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (recomendacao == null)
            const Center(child: CircularProgressIndicator())
          else
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          recomendacao.modal == ModalRecomendado.metro
                              ? Icons.directions_subway
                              : Icons.directions_car,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          recomendacao.modal == ModalRecomendado.metro
                              ? 'Va de metro/trem'
                              : 'Va de carro ou moto',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recomendacao.justificativa,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Metro/Trem: ${recomendacao.tempoMetroMin.round()} min',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: (recomendacao.tempoMetroMin /
                              (recomendacao.tempoMetroMin +
                                  recomendacao.tempoCarroMin))
                          .clamp(0.0, 1.0),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Carro/Moto: ${recomendacao.tempoCarroMin.round()} min',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: (recomendacao.tempoCarroMin /
                              (recomendacao.tempoMetroMin +
                                  recomendacao.tempoCarroMin))
                          .clamp(0.0, 1.0),
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gerada em ${_geradaEm?.hour.toString().padLeft(2, '0')}:'
                      '${_geradaEm?.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    Text(
                      'Voce seguiu esta recomendacao?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _registrarFeedback(true),
                            icon: const Icon(Icons.thumb_up_outlined),
                            label: const Text('Segui'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _registrarFeedback(false),
                            icon: const Icon(Icons.thumb_down_outlined),
                            label: const Text('Nao segui'),
                          ),
                        ),
                      ],
                    ),
                    if (_feedback != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _feedback!,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _gerarRecomendacao,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar recomendacao'),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'A ultima recomendacao fica salva apenas durante esta visita a '
            'tela. Transito e status das linhas sao simulados neste protótipo.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (_historico.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Historico (nesta sessao)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._historico.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(item),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
