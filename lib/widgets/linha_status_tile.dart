import 'package:flutter/material.dart';
import '../models/linha_status.dart';

Color _corLinha(int numero) {
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
      return const Color(0xFF1F2937);
  }
}

class LinhaStatusTile extends StatelessWidget {
  final LinhaStatus linha;

  const LinhaStatusTile({super.key, required this.linha});

  @override
  Widget build(BuildContext context) {
    final cor =
        linha.status == StatusLinha.normal ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _corLinha(linha.numero),
          child: Text(
            '${linha.numero}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(linha.nome),
        subtitle: Text(linha.tipo.label),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: cor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 10, color: cor),
              const SizedBox(width: 6),
              Text(
                linha.status.label,
                style: TextStyle(color: cor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
