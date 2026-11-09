import 'package:flutter/material.dart';
import '../models/rotina.dart';
import '../services/preferences_service.dart';
import '../services/rotina_service.dart';
import '../theme/theme_toggle_scope.dart';
import 'rotinas_screen.dart';
import 'nova_rotina_screen.dart';
import 'status_linhas_screen.dart';
import 'sobre_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  final RotinaService _rotinaService = RotinaService();

  List<Rotina> _rotinas = [];
  int _minutosEconomizados = 0;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final rotinas = await _preferencesService.getRotinas();
    final minutos = await _preferencesService.getMinutosEconomizados();

    setState(() {
      _rotinas = rotinas;
      _minutosEconomizados = minutos;
      _carregando = false;
    });
  }

  int get _rotinasAtivas => _rotinas.where((r) => r.ativa).length;

  Rotina? get _proximaSaida => _rotinaService.proximaSaida(_rotinas);

  String get _avisoTexto {
    final rotinasAtivas = _rotinas.where((r) => r.ativa).toList();
    if (rotinasAtivas.isEmpty) {
      return 'Cadastre uma rotina para receber alertas e recomendações.';
    }

    final linhas = rotinasAtivas.expand((r) => r.linhas).toSet().toList();

    if (linhas.isEmpty) {
      return 'Linhas preferenciais ainda não definidas. Ajuste sua rotina.';
    }

    return 'Atenção: confira a operação das linhas ${linhas.take(3).join(', ')} antes de sair.';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final proximaSaida = _proximaSaida;
    final themeToggle =
        ThemeToggleScope.of(context)?.toggleTheme ?? widget.onThemeToggle;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B3CFF), Color(0xFF00A651)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_transit,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            const Text('TransitaSP'),
          ],
        ),
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
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _avisoTexto,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (proximaSaida != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Próxima saída',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.schedule,
                                    color: Colors.indigo),
                                const SizedBox(width: 8),
                                Text(
                                  proximaSaida.horarioSaida,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${proximaSaida.origem} → ${proximaSaida.destino}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              proximaSaida.nome,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.timer_outlined,
                                    color: Colors.green),
                                const SizedBox(height: 8),
                                Text(
                                  '$_minutosEconomizados min',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('economizados'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.alt_route,
                                    color: Colors.indigo),
                                const SizedBox(height: 8),
                                Text(
                                  '$_rotinasAtivas/${_rotinas.length}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('rotinas ativas'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'O que voce quer fazer?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: const Text('Minhas rotinas'),
                      subtitle: const Text('Veja, edite e pause seus trajetos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RotinasScreen(),
                          ),
                        );
                        _carregarDados();
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.add_circle_outline),
                      title: const Text('Nova rotina'),
                      subtitle: const Text(
                          'Cadastre origem, destino, horario e modais'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final criada = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => const NovaRotinaScreen(),
                          ),
                        );
                        if (!mounted) return;
                        _carregarDados();
                        if (criada == true) {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RotinasScreen(),
                            ),
                          );
                          _carregarDados();
                        }
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.directions_subway_outlined),
                      title: const Text('Status das linhas'),
                      subtitle: const Text('Situacao de metro e trem agora'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const StatusLinhasScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Sobre o TransitaSP'),
                      subtitle: const Text('Problema, publico e ODS da ONU'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SobreScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Protótipo acadêmico · Global Solution FIAP 2026. '
                    'Trânsito e status das linhas são simulados.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
