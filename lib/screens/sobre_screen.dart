import 'package:flutter/material.dart';
import '../theme/theme_toggle_scope.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeToggle = ThemeToggleScope.of(context)?.toggleTheme ?? () {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o TransitaSP'),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/'
              'Metro_de_Sao_Paulo_Logo.svg/320px-Metro_de_Sao_Paulo_Logo.svg.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.indigo.shade50,
                  child: const Center(
                    child: Icon(Icons.directions_transit, size: 48),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _secao(
            titulo: 'O problema',
            texto: 'Quem trabalha na Grande Sao Paulo sai de casa sem saber '
                'qual e o melhor jeito de chegar hoje. O paulistano gasta '
                'em media 2h25 por dia em deslocamentos.',
          ),
          _secao(
            titulo: 'Para quem',
            texto: 'Trabalhadores que fazem o trajeto casa-trabalho na Grande '
                'Sao Paulo e podem escolher entre metro ou trem e carro ou moto.',
          ),
          _secao(
            titulo: 'A proposta',
            texto: 'O usuario cadastra a rotina uma vez (origem, destino, '
                'horario, dias e modais). O TransitaSP compara os modais e '
                'indica um caminho, e o usuario diz se seguiu a recomendacao.',
          ),
          const SizedBox(height: 8),
          const Text(
            'Objetivos de Desenvolvimento Sustentavel',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _odsCard(
            numero: '11',
            cor: Colors.orange,
            titulo: 'Cidades e comunidades sustentaveis',
            texto: 'Meta 11.2: acesso a transporte seguro e sustentavel.',
          ),
          _odsCard(
            numero: '9',
            cor: Colors.deepOrange,
            titulo: 'Industria, inovacao e infraestrutura',
            texto: 'Usa dados e um motor de recomendacao para aproveitar '
                'melhor a infraestrutura de transporte existente.',
          ),
          _odsCard(
            numero: '13',
            cor: Colors.green,
            titulo: 'Acao contra a mudanca global do clima',
            texto: 'Ao incentivar o transporte coletivo, reduz emissoes. '
                'Clima e alagamentos ficam como evolucao futura.',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Equipe Turbo · FIAP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Rafael Vitor de Almeida - RM 559116'),
                  Text('Vitor Silva Batista - RM 558865'),
                  Text('Enzo Demitrius Carvalhaes - RM 558912'),
                  SizedBox(height: 8),
                  Text(
                    'Protótipo academico da Global Solution 2026.2 '
                    '(desafio CitizenTech). Nao ha integracao com servicos '
                    'oficiais de transito/linhas: dados simulados.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _secao({required String titulo, required String texto}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(texto),
          ],
        ),
      ),
    );
  }

  Widget _odsCard({
    required String numero,
    required Color cor,
    required String titulo,
    required String texto,
  }) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(backgroundColor: cor, child: Text(numero)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(texto),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
