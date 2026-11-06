import 'package:flutter/material.dart';
import '../models/linha_status.dart';
import '../services/status_linhas_service.dart';
import '../theme/theme_toggle_scope.dart';
import '../widgets/linha_status_tile.dart';

class StatusLinhasScreen extends StatefulWidget {
  const StatusLinhasScreen({super.key});

  @override
  State<StatusLinhasScreen> createState() => _StatusLinhasScreenState();
}

class _StatusLinhasScreenState extends State<StatusLinhasScreen> {
  final StatusLinhasService _statusLinhasService = StatusLinhasService();

  List<LinhaStatus> _linhas = [];
  DateTime _atualizadoEm = DateTime.now();

  @override
  void initState() {
    super.initState();
    _atualizar();
  }

  void _atualizar() {
    setState(() {
      _linhas = _statusLinhasService.gerarStatusSimulado();
      _atualizadoEm = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hora = '${_atualizadoEm.hour.toString().padLeft(2, '0')}:'
        '${_atualizadoEm.minute.toString().padLeft(2, '0')}';

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeToggle = ThemeToggleScope.of(context)?.toggleTheme ?? () {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status das linhas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _atualizar,
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            tooltip: isDarkMode ? 'Ativar modo claro' : 'Ativar modo escuro',
            onPressed: themeToggle,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dados simulados para demonstracao. Atualizado em $hora.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _linhas.length,
              itemBuilder: (context, index) {
                return LinhaStatusTile(linha: _linhas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
