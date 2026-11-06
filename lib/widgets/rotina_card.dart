import 'package:flutter/material.dart';
import '../models/rotina.dart';

class RotinaCard extends StatelessWidget {
  final Rotina rotina;
  final VoidCallback onTap;
  final ValueChanged<bool> onAtivaChanged;
  final VoidCallback onExcluir;

  const RotinaCard({
    super.key,
    required this.rotina,
    required this.onTap,
    required this.onAtivaChanged,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      rotina.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Switch(
                    value: rotina.ativa,
                    onChanged: onAtivaChanged,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onExcluir,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text('${rotina.origem} -> ${rotina.destino}'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 4),
                  Text('Sai as ${rotina.horarioSaida}'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      rotina.diasSemana.join(', '),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children:
                    rotina.modais.map((m) => Chip(label: Text(m))).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
