# TransitaSP — App mobile (Flutter)

Projeto da disciplina de Desenvolvimento Cross Platform, referente à **Global Solution 2026.2 — CitizenTech**.
O **TransitaSP** ajuda o trabalhador a decidir, antes de sair de casa, qual é a melhor forma de chegar ao trabalho hoje, comparando metrô/trem com carro ou moto.

- Repositório: https://github.com/lkd8/TransitaSP

## Vídeo pitch

Link do vídeo: 

## Desenvolvedores

| Nome completo             | RM     |
| ------------------------- | ------ |
| Enzo Demitrius Carvalhaes | 558912 |
| Rafael Vitor de Almeida   | 559116 |
| Vitor Silva Batista       | 558865 |

## Descrição da solução

O usuário cadastra uma rotina (origem, destino, horário de saída, dias da semana, modais e tempos estimados). A partir dela, o app apresenta a **recomendação do dia** entre metrô/trem e carro/moto, e o usuário informa se seguiu ou não a recomendação, acumulando os **minutos economizados**.

## Tema da Global Solution

CitizenTech: mobilidade do trabalhador na Grande São Paulo, relacionada aos ODS 11 (Cidades e comunidades sustentáveis), 9 (Indústria, inovação e infraestrutura) e 13 (Ação contra a mudança global do clima).

Não existe API pública oficial para o status das linhas de metrô/trem nem para o trânsito. Por isso, o status das linhas e o fator de trânsito usados na recomendação são **simulados localmente**, e isso fica declarado nas telas do app.

## Fluxo de telas

```
Splash
  -> (primeira vez)  Onboarding (3 páginas) -> Home
  -> (já visitou)    Home

Home
 ├── Minhas rotinas
 │     ├── Nova rotina (volta para Minhas rotinas)
 │     └── [toque no item] -> Recomendação da rotina (detalhe)
 ├── Nova rotina
 ├── Status das linhas (simulado)
 └── Sobre o TransitaSP
```

- **Splash**: exibe o logo, verifica no `SharedPreferences` se o onboarding já foi visto e direciona automaticamente para Onboarding ou Home.
- **Onboarding**: 3 páginas (`PageView`) com ícone, título e descrição, botões Avançar/Voltar e opção "Não mostrar novamente", salva ao finalizar.
- **Home**: resumo (minutos economizados, rotinas ativas), aviso sobre as linhas da próxima saída e atalhos para as demais telas.
- **Minhas rotinas**: lista com busca, ativar/pausar (`Switch`) e exclusão com confirmação (`AlertDialog`). O toque no item abre a recomendação.
- **Nova rotina**: formulário validado, com busca de endereço por CEP para origem e destino (WebService).
- **Recomendação**: recebe a `Rotina` como parâmetro, compara os modais e permite "Segui" / "Não segui" e atualizar a recomendação.
- **Status das linhas**: lista simulada de linhas de metrô/trem com atualização manual.
- **Sobre**: problema, público, proposta, ODS e equipe.
- **Navegação**: `Navigator.push` / `Navigator.pop` entre as 6 telas principais, com passagem de parâmetros e retorno às telas anteriores.

## Capturas de tela

<table>
  <tr>
    <td><img src="prints/1.png" alt="Tela 1" width="100%"></td>
    <td><img src="prints/2.png" alt="Tela 2" width="100%"></td>
    <td><img src="prints/3.png" alt="Tela 3" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/4.png" alt="Tela 4" width="100%"></td>
    <td><img src="prints/5.png" alt="Tela 5" width="100%"></td>
    <td><img src="prints/6.png" alt="Tela 6" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/7.png" alt="Tela 7" width="100%"></td>
    <td><img src="prints/8.png" alt="Tela 8" width="100%"></td>
    <td><img src="prints/9.png" alt="Tela 9" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/10.png" alt="Tela 10" width="100%"></td>
    <td><img src="prints/11.png" alt="Tela 11" width="100%"></td>
    <td><img src="prints/12.png" alt="Tela 12" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/13.png" alt="Tela 13" width="100%"></td>
    <td><img src="prints/14.png" alt="Tela 14" width="100%"></td>
    <td><img src="prints/15.png" alt="Tela 15" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/16.png" alt="Tela 16" width="100%"></td>
    <td><img src="prints/17.png" alt="Tela 17" width="100%"></td>
    <td><img src="prints/18.png" alt="Tela 18" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/19.png" alt="Tela 19" width="100%"></td>
    <td><img src="prints/20.png" alt="Tela 20" width="100%"></td>
    <td><img src="prints/21.png" alt="Tela 21" width="100%"></td>
  </tr>
  <tr>
    <td><img src="prints/22.png" alt="Tela 22" width="100%"></td>
    <td><img src="prints/23.png" alt="Tela 23" width="100%"></td>
    <td><img src="prints/24.png" alt="Tela 24" width="100%"></td>
  </tr>
</table>

## API utilizada (WebService)

API REST pública e gratuita, sem necessidade de chave: **ViaCEP** (`https://viacep.com.br/ws/{cep}/json/`).

Na tela **Nova rotina**, o usuário digita o CEP de **origem** e/ou de **destino** e toca em buscar. O app faz a requisição HTTP (`package:http`), converte o JSON em um objeto Dart (`Endereco.fromJson`) e preenche automaticamente o campo correspondente. Cada campo trata os 4 estados pedidos no enunciado:

- **Inicial**: nenhuma consulta feita ainda.
- **Carregamento**: `CircularProgressIndicator` enquanto aguarda a resposta.
- **Sucesso**: endereço exibido e campo preenchido.
- **Erro**: mensagem adequada (CEP vazio, inválido, não encontrado ou falha de rede) com botão **Tentar novamente**.

O status das linhas e o motor de recomendação (comparação de tempos entre os modais) são simulados localmente, conforme explicado acima.

## Persistência local

`shared_preferences` (`SharedPreferencesAsync`) guarda:

- se o onboarding já foi visto;
- a lista de rotinas cadastradas (serializadas em JSON);
- o total de minutos economizados (feedback "Segui" / "Não segui");
- o tema escolhido (claro, escuro ou do sistema).

## Interações implementadas

1. Toque em um item da lista "Minhas rotinas" abre a tela de detalhes (Recomendação), com passagem de parâmetro.
2. Busca/filtro de rotinas por nome, origem ou destino.
3. Ativar/pausar uma rotina (`Switch`) e excluir com confirmação (`AlertDialog`).
4. Botões "Segui" / "Não segui", atualizando o estado visual e o total de minutos economizados.
5. Botão "Atualizar recomendação", que gera uma nova simulação.
6. Atualização manual do status das linhas.
7. Consulta de CEP (origem e destino) com opção de tentar novamente em caso de erro.
8. Alternância entre modo claro e escuro em todas as telas, com a escolha salva.

## Arquitetura / organização do projeto

```
lib/
├── main.dart                         # MaterialApp, temas claro/escuro e estado do tema
├── models/
│   ├── rotina.dart                   # rotina cadastrada (fromJson/toJson)
│   ├── endereco.dart                 # resposta da API ViaCEP (fromJson)
│   └── linha_status.dart             # linha de metrô/trem simulada (enums com label)
├── services/
│   ├── preferences_service.dart      # SharedPreferences (onboarding, rotinas, minutos, tema)
│   ├── endereco_service.dart         # consumo HTTP da API ViaCEP
│   ├── status_linhas_service.dart    # geração do status simulado das linhas
│   ├── recomendacao_service.dart     # motor de recomendação (comparação de tempos)
│   └── rotina_service.dart           # regras para próxima saída e cores das linhas
├── theme/
│   └── theme_toggle_scope.dart       # InheritedWidget que expõe a troca de tema às telas
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── rotinas_screen.dart
│   ├── nova_rotina_screen.dart
│   ├── recomendacao_screen.dart
│   ├── status_linhas_screen.dart
│   └── sobre_screen.dart
└── widgets/
    ├── rotina_card.dart              # card reutilizável de rotina
    └── linha_status_tile.dart        # item reutilizável de status de linha
```

A separação segue o padrão `models / services / screens / widgets`: as telas (`StatefulWidget`) cuidam da interface e chamam os `services` para persistência, consumo HTTP e regras de negócio, sem lógica de negócio dentro das telas. O estado é gerenciado com `setState`, sem bibliotecas externas de gerenciamento de estado. Os widgets `RotinaCard` e `LinhaStatusTile` são reutilizados nas telas, e `SobreScreen` é `StatelessWidget` por não ter estado.

## Widgets e conceitos utilizados

`Scaffold`, `AppBar`, `Column`, `Row`, `Card`, `ListView`, `PageView`, `Form`/`TextFormField` com `validator`, `CheckboxListTile`, `Switch`, `AlertDialog`, `SnackBar`, `ElevatedButton`, `OutlinedButton`, `TextButton`, `Icon`, `IconButton`, `Image.network` (com `errorBuilder`), `StatefulWidget`/`StatelessWidget`, `setState`, `Navigator`, `shared_preferences` e `http`.

## Como executar

Pré-requisito: Flutter instalado.

```bash
flutter pub get
flutter run
```

## Observações

- Protótipo acadêmico (Global Solution FIAP 2026.2). Não há integração com serviços oficiais de trânsito ou de status das linhas: esses dados são simulados, conforme declarado nas próprias telas.
- A única chamada de rede real do app é a consulta pública ao ViaCEP, usada no cadastro da rotina.
