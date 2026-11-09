import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:transita_sp/screens/nova_rotina_screen.dart';

void main() {
  testWidgets('exibe retry e permite repetir uma consulta de CEP com erro',
      (tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();

    await tester.pumpWidget(
      const MaterialApp(home: NovaRotinaScreen()),
    );

    final botaoBuscaOrigem = find.byIcon(Icons.search).first;
    await tester.ensureVisible(botaoBuscaOrigem);
    await tester.tap(botaoBuscaOrigem);
    await tester.pumpAndSettle();

    expect(find.text('Informe um CEP para buscar.'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);

    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();

    expect(find.text('Informe um CEP para buscar.'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
