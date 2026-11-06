import 'package:flutter/material.dart';
import '../theme/theme_toggle_scope.dart';
import '../models/rotina.dart';
import '../models/endereco.dart';
import '../services/preferences_service.dart';
import '../services/endereco_service.dart';

enum StatusConsultaCep { inicial, carregando, sucesso, erro }

const List<String> _diasDaSemana = [
  'Seg',
  'Ter',
  'Qua',
  'Qui',
  'Sex',
  'Sab',
  'Dom'
];
const List<String> _modaisDisponiveis = ['Metro/Trem', 'Carro', 'Moto'];
const List<String> _linhasDisponiveis = [
  'Linha 1-Azul',
  'Linha 2-Verde',
  'Linha 3-Vermelha',
  'Linha 4-Amarela',
  'Linha 5-Lilas',
  'Linha 7-Rubi',
  'Linha 9-Esmeralda',
  'Linha 11-Coral',
  'Linha 13-Jade',
  'Linha 15-Prata',
];

class NovaRotinaScreen extends StatefulWidget {
  const NovaRotinaScreen({super.key});

  @override
  State<NovaRotinaScreen> createState() => _NovaRotinaScreenState();
}

class _NovaRotinaScreenState extends State<NovaRotinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final PreferencesService _preferencesService = PreferencesService();
  final EnderecoService _enderecoService = EnderecoService();

  final _nomeController = TextEditingController(text: 'Casa -> Trabalho');
  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();
  final _horarioController = TextEditingController(text: '07:30');
  final _tempoMetroController = TextEditingController();
  final _tempoCarroController = TextEditingController();
  final _cepOrigemController = TextEditingController();
  final _cepDestinoController = TextEditingController();

  final Set<String> _diasSelecionados = {'Seg', 'Ter', 'Qua', 'Qui', 'Sex'};
  final Set<String> _modaisSelecionados = {'Metro/Trem', 'Carro'};
  final Set<String> _linhasSelecionadas = {'Linha 1-Azul'};

  StatusConsultaCep _statusCepOrigem = StatusConsultaCep.inicial;
  StatusConsultaCep _statusCepDestino = StatusConsultaCep.inicial;
  String _mensagemErroCepOrigem = '';
  String _mensagemErroCepDestino = '';

  @override
  void dispose() {
    _nomeController.dispose();
    _origemController.dispose();
    _destinoController.dispose();
    _horarioController.dispose();
    _tempoMetroController.dispose();
    _tempoCarroController.dispose();
    _cepOrigemController.dispose();
    _cepDestinoController.dispose();
    super.dispose();
  }

  Future<void> _consultarCepOrigem() async {
    if (_cepOrigemController.text.trim().isEmpty) {
      setState(() {
        _statusCepOrigem = StatusConsultaCep.erro;
        _mensagemErroCepOrigem = 'Informe um CEP para buscar.';
      });
      return;
    }

    setState(() {
      _statusCepOrigem = StatusConsultaCep.carregando;
    });

    try {
      final Endereco endereco =
          await _enderecoService.buscarPorCep(_cepOrigemController.text);

      if (!mounted) return;
      setState(() {
        _statusCepOrigem = StatusConsultaCep.sucesso;
        _mensagemErroCepOrigem = '';
        _origemController.text = endereco.resumo;
      });
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _statusCepOrigem = StatusConsultaCep.erro;
        _mensagemErroCepOrigem =
            erro.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _consultarCepDestino() async {
    if (_cepDestinoController.text.trim().isEmpty) {
      setState(() {
        _statusCepDestino = StatusConsultaCep.erro;
        _mensagemErroCepDestino = 'Informe um CEP para buscar.';
      });
      return;
    }

    setState(() {
      _statusCepDestino = StatusConsultaCep.carregando;
    });

    try {
      final Endereco endereco =
          await _enderecoService.buscarPorCep(_cepDestinoController.text);

      if (!mounted) return;
      setState(() {
        _statusCepDestino = StatusConsultaCep.sucesso;
        _mensagemErroCepDestino = '';
        _destinoController.text = endereco.resumo;
      });
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _statusCepDestino = StatusConsultaCep.erro;
        _mensagemErroCepDestino =
            erro.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _salvarRotina() async {
    if (!_formKey.currentState!.validate()) return;

    if (_diasSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um dia da semana.')),
      );
      return;
    }

    if (_modaisSelecionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um modal.')),
      );
      return;
    }

    final novaRotina = Rotina(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      origem: _origemController.text.trim(),
      destino: _destinoController.text.trim(),
      horarioSaida: _horarioController.text.trim(),
      diasSemana: _diasDaSemana.where(_diasSelecionados.contains).toList(),
      modais: _modaisDisponiveis.where(_modaisSelecionados.contains).toList(),
      linhas: _linhasDisponiveis.where(_linhasSelecionadas.contains).toList(),
      tempoMetroMin: double.tryParse(_tempoMetroController.text) ?? 0,
      tempoCarroMin: double.tryParse(_tempoCarroController.text) ?? 0,
    );

    final rotinas = await _preferencesService.getRotinas();
    rotinas.add(novaRotina);
    await _preferencesService.saveRotinas(rotinas);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  String? _validarObrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio';
    }
    return null;
  }

  String? _validarHorario(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio';
    }
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    if (!regex.hasMatch(valor.trim())) {
      return 'Use o formato HH:mm, por exemplo 07:30';
    }
    return null;
  }

  String? _validarNumero(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatorio';
    }
    if (double.tryParse(valor) == null) {
      return 'Informe um numero valido';
    }
    return null;
  }

  Widget _buildConsultaCep({
    required String titulo,
    required TextEditingController cepController,
    required TextEditingController enderecoController,
    required StatusConsultaCep status,
    required String mensagemErro,
    required String textoSucesso,
  }) {
    switch (status) {
      case StatusConsultaCep.carregando:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Consultando CEP...'),
            ],
          ),
        );
      case StatusConsultaCep.sucesso:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(textoSucesso)),
            ],
          ),
        );
      case StatusConsultaCep.erro:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(mensagemErro)),
                ],
              ),
            ],
          ),
        );
      case StatusConsultaCep.inicial:
        return const SizedBox.shrink();
    }
  }

  Color _corLinhaPorNome(String linha) {
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
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeToggle = ThemeToggleScope.of(context)?.toggleTheme ?? () {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova rotina'),
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Identificacao',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da rotina',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarObrigatorio,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Buscar endereco de origem por CEP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Consulta a API publica ViaCEP (http). Opcional: voce '
                  'tambem pode preencher a Origem manualmente abaixo.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cepOrigemController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'CEP da origem',
                          hintText: '01310-100',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _consultarCepOrigem,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                _buildConsultaCep(
                  titulo: 'CEP da origem',
                  cepController: _cepOrigemController,
                  enderecoController: _origemController,
                  status: _statusCepOrigem,
                  mensagemErro: _mensagemErroCepOrigem,
                  textoSucesso: 'Endereco preenchido na origem.',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _origemController,
                  decoration: const InputDecoration(
                    labelText: 'Origem',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarObrigatorio,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Buscar endereco de destino por CEP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Use o CEP do destino para preencher automaticamente o campo abaixo.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cepDestinoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'CEP do destino',
                          hintText: '04200-000',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _consultarCepDestino,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                _buildConsultaCep(
                  titulo: 'CEP do destino',
                  cepController: _cepDestinoController,
                  enderecoController: _destinoController,
                  status: _statusCepDestino,
                  mensagemErro: _mensagemErroCepDestino,
                  textoSucesso: 'Endereco preenchido no destino.',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _destinoController,
                  decoration: const InputDecoration(
                    labelText: 'Destino',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarObrigatorio,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 8),
                const Text(
                  'Quando voce sai',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _horarioController,
                  decoration: const InputDecoration(
                    labelText: 'Horario de saida (HH:mm)',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarHorario,
                ),
                const SizedBox(height: 8),
                const Text('Dias da semana'),
                Wrap(
                  children: _diasDaSemana.map((dia) {
                    final selecionado = _diasSelecionados.contains(dia);
                    return CheckboxListTile(
                      dense: true,
                      title: Text(dia),
                      value: selecionado,
                      onChanged: (valor) {
                        setState(() {
                          if (valor == true) {
                            _diasSelecionados.add(dia);
                          } else {
                            _diasSelecionados.remove(dia);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Linhas de metrô e trem',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _linhasDisponiveis.map((linha) {
                    final selecionada = _linhasSelecionadas.contains(linha);
                    final cor = _corLinhaPorNome(linha);

                    return ChoiceChip(
                      label: Text(linha),
                      selected: selecionada,
                      selectedColor: cor.withValues(alpha: 0.22),
                      avatar: CircleAvatar(
                        backgroundColor: cor,
                        radius: 10,
                        child: Text(
                          linha
                              .split('-')
                              .first
                              .replaceAll(RegExp(r'[^0-9]'), ''),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onSelected: (_) {
                        setState(() {
                          if (selecionada) {
                            _linhasSelecionadas.remove(linha);
                          } else {
                            _linhasSelecionadas.add(linha);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Como voce pode ir',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ..._modaisDisponiveis.map((modal) {
                  final selecionado = _modaisSelecionados.contains(modal);
                  return CheckboxListTile(
                    title: Text(modal),
                    value: selecionado,
                    onChanged: (valor) {
                      setState(() {
                        if (valor == true) {
                          _modaisSelecionados.add(modal);
                        } else {
                          _modaisSelecionados.remove(modal);
                        }
                      });
                    },
                  );
                }),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tempoMetroController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tempo de metro/trem em dia normal (min)',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarNumero,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tempoCarroController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tempo de carro/moto sem transito (min)',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validarNumero,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _salvarRotina,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Salvar rotina'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
