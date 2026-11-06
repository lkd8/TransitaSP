import 'package:flutter/material.dart';
import '../models/rotina.dart';
import '../services/preferences_service.dart';
import '../theme/theme_toggle_scope.dart';
import '../widgets/rotina_card.dart';
import 'nova_rotina_screen.dart';
import 'recomendacao_screen.dart';

class RotinasScreen extends StatefulWidget {
  const RotinasScreen({super.key});

  @override
  State<RotinasScreen> createState() => _RotinasScreenState();
}

class _RotinasScreenState extends State<RotinasScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  final TextEditingController _buscaController = TextEditingController();

  List<Rotina> _rotinas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRotinas();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregarRotinas() async {
    final rotinas = await _preferencesService.getRotinas();
    setState(() {
      _rotinas = rotinas;
      _carregando = false;
    });
  }

  List<Rotina> get _rotinasFiltradas {
    final termo = _buscaController.text.trim().toLowerCase();
    if (termo.isEmpty) return _rotinas;

    return _rotinas.where((r) {
      return r.nome.toLowerCase().contains(termo) ||
          r.origem.toLowerCase().contains(termo) ||
          r.destino.toLowerCase().contains(termo);
    }).toList();
  }

  Future<void> _alternarAtiva(Rotina rotina, bool ativa) async {
    setState(() {
      rotina.ativa = ativa;
    });
    await _preferencesService.saveRotinas(_rotinas);
  }

  Future<void> _excluirRotina(Rotina rotina) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir rotina?'),
        content: Text('Deseja excluir a rotina "${rotina.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() {
      _rotinas.removeWhere((r) => r.id == rotina.id);
    });
    await _preferencesService.saveRotinas(_rotinas);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rotina "${rotina.nome}" excluida.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visiveis = _rotinasFiltradas;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeToggle = ThemeToggleScope.of(context)?.toggleTheme ?? () {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas rotinas'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NovaRotinaScreen()),
          );
          _carregarRotinas();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova rotina'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _buscaController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Buscar rotina',
                      hintText: 'Nome, origem ou destino',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('${visiveis.length} rotina(s)'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: visiveis.isEmpty
                        ? const Center(
                            child: Text('Nenhuma rotina encontrada.'),
                          )
                        : ListView.builder(
                            itemCount: visiveis.length,
                            itemBuilder: (context, index) {
                              final rotina = visiveis[index];
                              return RotinaCard(
                                rotina: rotina,
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => RecomendacaoScreen(
                                        rotina: rotina,
                                      ),
                                    ),
                                  );
                                  _carregarRotinas();
                                },
                                onAtivaChanged: (valor) =>
                                    _alternarAtiva(rotina, valor),
                                onExcluir: () => _excluirRotina(rotina),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
