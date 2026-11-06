import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/theme_toggle_scope.dart';
import 'home_screen.dart';

class _PaginaOnboarding {
  final IconData icone;
  final String titulo;
  final String descricao;

  const _PaginaOnboarding({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const OnboardingScreen({super.key, required this.onThemeToggle});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PreferencesService _preferencesService = PreferencesService();
  final PageController _pageController = PageController();

  int _paginaAtual = 0;
  bool _naoMostrarNovamente = true;

  final List<_PaginaOnboarding> _paginas = const [
    _PaginaOnboarding(
      icone: Icons.directions_transit,
      titulo: 'Saiba como chegar ao trabalho',
      descricao: 'O TransitaSP ajuda quem se desloca na Grande Sao Paulo a '
          'decidir, antes de sair de casa, qual e o melhor jeito de '
          'chegar ao trabalho hoje.',
    ),
    _PaginaOnboarding(
      icone: Icons.compare_arrows,
      titulo: 'Compare metro/trem e carro ou moto',
      descricao: 'Cadastre sua rotina uma vez (origem, destino, horario e '
          'modais) e o app compara os tempos estimados de cada opcao.',
    ),
    _PaginaOnboarding(
      icone: Icons.notifications_active_outlined,
      titulo: 'Receba uma recomendacao do dia',
      descricao: 'O app cruza o status das linhas (simulado neste protótipo) '
          'com o transito e indica o melhor caminho antes da sua saida.',
    ),
  ];

  void _irParaProximaPagina() {
    if (_paginaAtual == _paginas.length - 1) {
      _finalizarOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _irParaPaginaAnterior() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finalizarOnboarding() async {
    await _preferencesService.saveOnboardingVisto(_naoMostrarNovamente);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(onThemeToggle: widget.onThemeToggle),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ultimaPagina = _paginaAtual == _paginas.length - 1;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeToggle = ThemeToggleScope.of(context)?.toggleTheme ?? () {};

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 16,
              child: IconButton(
                onPressed: themeToggle,
                icon: Icon(
                  isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                ),
                tooltip:
                    isDarkMode ? 'Ativar modo claro' : 'Ativar modo escuro',
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _paginas.length,
                    onPageChanged: (index) {
                      setState(() {
                        _paginaAtual = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final pagina = _paginas[index];
                      return Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(pagina.icone, size: 96, color: Colors.indigo),
                            const SizedBox(height: 32),
                            Text(
                              pagina.titulo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              pagina.descricao,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_paginas.length, (index) {
                    final ativo = index == _paginaAtual;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: ativo ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ativo ? Colors.indigo : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _naoMostrarNovamente,
                  onChanged: (value) {
                    setState(() {
                      _naoMostrarNovamente = value ?? true;
                    });
                  },
                  title: const Text('Nao mostrar novamente'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      if (_paginaAtual > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _irParaPaginaAnterior,
                            child: const Text('Voltar'),
                          ),
                        ),
                      if (_paginaAtual > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _irParaProximaPagina,
                          child: Text(ultimaPagina ? 'Comecar' : 'Avancar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
