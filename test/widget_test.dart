import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:transita_sp/main.dart';

void main() {
  testWidgets('exibe a tela inicial do TransitaSP', (tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();

    await tester.pumpWidget(const TransitaSPApp());
    await tester.pump();

    expect(find.text('TransitaSP'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Saiba como chegar ao trabalho'), findsOneWidget);
  });
}
