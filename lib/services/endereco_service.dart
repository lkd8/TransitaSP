import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco.dart';

class EnderecoService {
  static const String baseUrl = 'https://viacep.com.br/ws';

  Future<Endereco> buscarPorCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');

    if (cepLimpo.length != 8) {
      throw Exception(
        'CEP inválido. Informe 8 dígitos e tente novamente.',
      );
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$cepLimpo/json/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao consultar o CEP (${response.statusCode}).');
    }

    final json = jsonDecode(response.body);

    if (json['erro'] == true) {
      throw Exception(
        'CEP inválido ou não encontrado. Verifique o número e tente novamente.',
      );
    }

    return Endereco.fromJson(json);
  }
}
